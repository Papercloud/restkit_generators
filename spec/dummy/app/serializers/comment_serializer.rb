class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :post_id
end
