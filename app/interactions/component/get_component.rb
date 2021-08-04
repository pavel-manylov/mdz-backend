# Получение компонента по идентификатору
class GetComponent < ActiveInteraction::Base
  # @!attribute component_id
  #   Идентификатор компонента
  #
  #   @validation Обязателен для заполнения
  #   @validation Соответствует существующему компоненту
  #   @return [Integer]
  integer :component_id

  # @return [NilClass, Component]
  def execute
    component = Component.find_by_id(component_id)
    errors.add(:component_id, 'Component not found') if component.nil?
    component
  end
end