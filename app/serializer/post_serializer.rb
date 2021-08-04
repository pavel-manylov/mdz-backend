# Сериализатор публикации (публикаций)
class PostSerializer
  class << self
    # Сериализует публикацию (публикации)
    # Ключи в сериализованном значении:
    #
    #   - id      — идентификатор
    #   - name    — название
    #   - seo_url — человекочитаемый URL
    #
    # @param  [Post, Array<Post>]  post
    # @return [Hash, Array<Hash>]
    def serialize(post)
      post.as_json only: %w(id name seo_url)
    end
  end
end