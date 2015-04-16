class Member
  include Mongoid::Document

  LEVEL = [
    0, 
    1,
    5,
    15,
    30,
    50,
    100,
    200,
    500,
    1000,
    2000,
    3000,
    6000,
    10000,
    18000,
    30000,
    60000,
    100000,
    180000,
    300000]

  ROLE_SCORES = [
    0,
    1.5,
    2]

  ROLE_DESC = [
    '吧友',
    '小吧',
    '大吧'
  ]

  ADMINS = {
    # 吧主
    '人渣诚伊藤诚囧': 2,
    'pad13':        2,
    '法兰西岛伯爵':   2,
    # 小吧主
    '不被原谅的魂':   1,
    'gypbrf':       1,
    '舟之骸':        1,
    '台南鄉民':       1,
    '瓦良吉小队长':   1,
    '酸奶鱼块':       1,
    'abcdgh':         1,
    'wbxz1629':     1,
    '血染的文明':    1,
    'Kar_loku':     1
  }
  MODDER_LIST = [
    '台南鄉民',
    '法兰西岛伯爵',
    'wbxz1629',
    '谦逊的豌豆'
  ]

  field :name, type: String
  field :link, type: String, default: ->{''}
  field :score, type: Integer, default: ->{0}

  validates_uniqueness_of :name
  has_many :highlights

  def highlights_count
    Highlight.where(author: self).count
  end

  def role
    admin = ADMINS[name.to_sym]
    admin ? admin : 0
  end

  def is_modder?
    MODDER_LIST.include? name
  end

  def add_highlight(highlight)
    highlights << highlight
  end

  def role_desc
    ROLE_DESC[role]
  end

  def calculated_level
    level_low = LEVEL.select do |l| l <= score end.last
    level = LEVEL.index(level_low)
    next_level_score = LEVEL[level + 1] - level_low
    calculated_level = 
      level.to_f + (score - level_low).to_f / next_level_score
  end

  def point
    0.25 * (calculated_level ** 2) - 2.25 * calculated_level + 14 + 
    1.5 * highlights_count + 
    ROLE_SCORES[role] + 
    (is_modder? ? 2 : 0)
  end

  def point_may_use
    0.25 * (calculated_level ** 2) - 2.25 * calculated_level + 14 +
    30 * (1 - 0.95 ** highlights_count) +
    ROLE_SCORES[role] +
    (is_modder? ? 2 : 0)
  end


  index({name: 1}, {unique: true})

end
