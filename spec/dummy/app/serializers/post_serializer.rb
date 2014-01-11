class PostSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :name, :date
  has_many :tags
  has_many :comments
  has_one :user
end