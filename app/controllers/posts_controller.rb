class PostsController < ApplicationController
  # Список всех публикаций
  #
  # @example {include:file:../http/posts/index.http}
  def index
    posts = IndexPosts.run!
    render json: PostSerializer.serialize(posts)
  end

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
    post = CreatePost.run! post_params
    render json: PostSerializer.serialize(post)
  end

  # Обновляет указанную публикацию
  #
  # @example {include:file:../http/posts/update.http}
  def update
    update_params = post_params
    update_params[:post_id] = params[:id]

    post = UpdatePost.run! update_params

    render json: PostSerializer.serialize(post)
  end

  # Удаляет указанную публикацию
  #
  # @example {include:file:../http/posts/delete.http}
  def destroy
    DeletePost.run! post_id: params[:id]
    render json: {}
  end

  private

  # @return [Hash]
  def post_params
    params.permit(:name, :seo_url).to_h
  end
end