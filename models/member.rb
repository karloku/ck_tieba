class Member
  include Mongoid::Document
  paginates_per 100

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
    'gypbrf':       2,
    'pad13':        2,
    '法兰西岛伯爵':   2,
    # 小吧主
    '不被原谅的魂':   1,
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
    '谦逊的豌豆',
    'abcdgh',
    'Kar_loku'
  ]

  field :name, type: String
  field :link, type: String, default: ->{''}
  field :score, type: Integer, default: ->{0}
  field :point, type: Float, default: ->{0}
  field :point_may_use, type: Float, default: ->{0}

  validates_uniqueness_of :name
  has_many :highlights

  index name: 1
  index score: 1
  index point_may_use: 1, score: 1

  def highlights_count
    highlights.size
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
    level_low = LEVEL.select { |l| l <= score }.last
    level = LEVEL.index(level_low)
    next_level_score = LEVEL[level + 1] - level_low
    calculated_level = 
      BigDecimal.new(level) + BigDecimal.new(score - level_low) / BigDecimal.new(next_level_score)
  end

  def calc_level_point
    cl = calculated_level
    if cl < 6 
      0
    elsif cl < 8
      cl * 3 - 6
    else
      (BigDecimal.new('0.25') * (cl ** BigDecimal.new(2)) - BigDecimal.new('2.25') * cl + BigDecimal.new(14)).floor(1)
    end
  end

  def calc_point
    calc_level_point + 
    BigDecimal.new('1.5') * BigDecimal.new(highlights_count) + 
    BigDecimal.new(ROLE_SCORES[role].to_s) + 
    BigDecimal.new(is_modder? ? 2 : 0)
  end

  def calc_point_may_use
    calc_level_point +
    BigDecimal.new(30) * (BigDecimal.new(1) - BigDecimal.new('0.95') ** BigDecimal.new(highlights_count)) +
    BigDecimal.new(ROLE_SCORES[role].to_s) +
    BigDecimal.new(is_modder? ? 2 : 0)
  end

  before_save do
    self.point = calc_point
    self.point_may_use = calc_point_may_use
  end

end
