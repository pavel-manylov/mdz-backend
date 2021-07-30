# Пост (публикация), состоящая из связанных компонентов
class Post < ApplicationRecord
  # @!attribute name
  #   Внутреннее название поста
  #
  #   @validation обязателен для заполнения
  #   @return [String]

  # @!attribute draft
  #   Является ли пост черновиком
  #
  #   @validation обязателен для заполнения
  #   @return [Boolean]

  # @!attribute seo_url
  #   Человекочитаемый URL (часть URL)
  #
  #   @example "obama-care"
  #   @example "football-goes-home"
  #   @return [String]

  validates_presence_of :name
  validates_inclusion_of :draft, in: [true, false]
end
