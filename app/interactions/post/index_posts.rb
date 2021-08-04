# Получение списка всех публикаций
class IndexPosts < ActiveInteraction::Base
  # @return [Array<Post>]
  def execute
    Post.all.to_a
  end
end