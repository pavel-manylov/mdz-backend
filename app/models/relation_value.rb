# Значение-вложения компонента
class RelationValue < ApplicationRecord
  include ComponentValue

  # @!attribute relation_value_posts
  #   Промежуточные объекты, связывающие компонент-вложение с публикациями-вложениями
  #
  #   @api private
  #   @return [ActiveRecord::Relation<RelationValuePost>]
  has_many :relation_value_posts

  # @!attribute posts
  #   Публикации-вложения
  #   Рекомендуется использовать алиас {#value}, предоставляющий интерфейсную совместимость с другими `*Value` классами
  #
  #   @return [ActiveRecord::Relation<Post>]
  has_many :posts, through: :relation_value_posts

  alias_attribute :value, :posts
end
