class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :date
  has_many :tags
  has_many :comments
end
