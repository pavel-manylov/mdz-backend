# Сериализатор публикации
class PostSerializer
  class << self
    # Сериализует публикацию
    #
    # @param  [Post]  post
    # @return [Hash]
    def serialize(post)
      post.as_json only: %w(name seo_url)
    end
  end
end