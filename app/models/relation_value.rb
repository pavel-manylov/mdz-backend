class RelationValue < ApplicationRecord
  include ComponentValue

  has_many :relation_value_posts
  has_many :posts, through: :relation_value_posts

  has_many :draft_relation_value_posts
  has_many :draft_posts, through: :draft_relation_value_posts, source: :post

  def value
    return nil unless posts.present? || self.has_value?
    posts
  end

  # @param  [Array<Post>, NilClass] new_posts
  def value=(new_posts)
    self.posts = Array.wrap(new_posts)
    self.has_value = !new_posts.nil?
  end

  def draft_value
    return nil unless draft_posts.present? || self.has_draft_value?
    draft_posts
  end

  def draft_value=(new_draft_posts)
    self.draft_posts = Array.wrap(new_draft_posts)
    self.has_draft_value = !new_draft_posts.nil?
  end
end
