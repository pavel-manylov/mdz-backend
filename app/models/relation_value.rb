class RelationValue < ApplicationRecord
  include ComponentValue

  has_many :relation_value_posts
  has_many :posts, through: :relation_value_posts

  def value
    return nil unless posts.present? || self.has_value?
    posts
  end

  # @param  [Array<Post>, NilClass] new_posts
  def value=(new_posts)
    self.posts = Array.wrap(new_posts)
    self.has_value = !new_posts.nil?
  end
end
