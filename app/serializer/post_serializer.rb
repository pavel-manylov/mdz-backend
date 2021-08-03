# Сериализатор публикации
class PostSerializer
  class << self
    # Сериализует публикацию
    # Ключи в сериализованном значении:
    #
    #   - id      — идентификатор
    #   - name    — название
    #   - seo_url — человекочитаемый URL
    #
    # @param  [Post]  post
    # @return [Hash]
    def serialize(post)
      post.as_json only: %w(id name seo_url)
    end
  end
end