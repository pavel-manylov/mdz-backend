# Сервисный класс создания публикации
class CreatePost < ActiveInteraction::Base
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

  validates_presence_of :name

  # Создаёт новую публикацию
  #
  # @return [Post]  созданная публикация
  def execute
    Post.create! name: name, seo_url: seo_url
  end
end