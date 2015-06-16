class Post < ActiveRecord::Base
  has_many :comments, as: :commentable
  belongs_to :user
  has_and_belongs_to_many :tags
end
