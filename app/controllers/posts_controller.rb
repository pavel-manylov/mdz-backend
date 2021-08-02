class PostsController < ApplicationController
  # Создаёт и возвращает новую публикацию
  #
  # @example {include:file:../http/posts/create.http}
  def create
    post = CreatePost.run! params.permit(:name, :seo_url).to_h
    render json: PostSerializer.serialize(post)
  end
end