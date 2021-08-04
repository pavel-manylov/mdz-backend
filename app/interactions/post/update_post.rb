# Сервисный класс обновления публикации
class UpdatePost < ActiveInteraction::Base
  # @!attribute post_id
  #   Идентификатор публикации
  #
  #   @validation Обязателен для заполнения
  #   @validation Соответствует существующей публикации
  #   @return [Integer]
  integer :post_id

  # @!attribute name
  #   Название новой публикации
  #
  #   @validation Обязателен для заполнения
  #   @return [String]
  string :name

  # @!attribute seo_url
  #   Человекопонятный URL новой публикации
  #
  #   @return [String]
  string :seo_url

  # Обновляет публикацию
  #
  # @return [Post]
  def execute
    post = compose GetPost, post_id: post_id
    post.update name: name, seo_url: seo_url
    errors.merge! post.errors
    post
  end
end