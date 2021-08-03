class PostsController < ApplicationController
  # Возвращает публикацию по идентификатору
  #
  # @example {include:file:../http/posts/get.http}
  def show
    post = GetPost.run! post_id: params[:id]
    render json: PostSerializer.serialize(post)
  end

  # Создаёт и возвращает новую публикацию
  #
  # @example {include:file:../http/posts/create.http}
  def create
    post = CreatePost.run! params.permit(:name, :seo_url).to_h
    render json: PostSerializer.serialize(post)
  end
end