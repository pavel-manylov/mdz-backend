# Настраиваемое (кастомное) поле компонента
class CustomField < ApplicationRecord
  # @!attribute component
  #   Компонент, к которому относится данное поле
  #
  #   @validation Обязателен для заполнения
  #   @return [Component]
  belongs_to :component

  # @!attribute name
  #   Название поля
  #
  #   @validation Обязателен для заполнения
  #   @return [String]

  # @!attribute value
  #   Значение поля
  #
  #   @validation Обязателен для заполнения
  #   @return [String]

  validates_presence_of :value, :name
end
