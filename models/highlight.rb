class Highlight
  include Mongoid::Document

  field :title, type: String
  belongs_to :author, class_name: "Member"
  field :link, type: String

  index({title: 1}, {unique: true})
end