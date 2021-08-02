# Промежуточная модель для связи компонента-вложения с публикациями
# @api private
class RelationValuePost < ApplicationRecord
  # @!attribute relation_value
  #   Компонент-вложение публикации
  #
  #   @validation Обязателен для заполнения
  #   @return [RelationValue]
  belongs_to :relation_value

  # @!attribute post
  #   Публикация-вложение
  #
  #   @validation Обязателен для заполнения
  #   @return [Post]
  belongs_to :post
end
