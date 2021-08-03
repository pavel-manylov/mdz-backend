# Сервисный класс удаления компонента
class DeleteComponent < ActiveInteraction::Base
  # @!attribute component_id
  #   Идентификатор компонента
  #
  #   @validation Обязателен для заполнения
  #   @validation Соответствует существующему компоненту
  #   @return [Integer]
  integer :component_id

  # Удаляет компонент
  #
  # @return [TrueClass]
  def execute
    compose(GetComponent, component_id: component_id).destroy
    true
  end
end