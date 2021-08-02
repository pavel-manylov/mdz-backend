# Пост (публикация), состоящая из связанных компонентов
class Post < ApplicationRecord
  # @!attribute components
  #   Компоненты данной публикации.
  #   При удалении публикации автоматически удаляются все связанные компоненты
  #
  #   @return [ActiveRecord::Relation<Component>]

  has_many :components, dependent: :destroy

  # @!attribute name
  #   Внутреннее название поста
  #
  #   @validation обязателен для заполнения
  #   @return [String]

  # @!attribute seo_url
  #   Человекочитаемый URL (часть URL)
  #
  #   @example "obama-care"
  #   @example "football-goes-home"
  #   @return [String]

  validates_presence_of :name
end
