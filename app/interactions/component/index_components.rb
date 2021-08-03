# Получение списка компонентов публикации
class IndexComponents < ActiveInteraction::Base
  # @!attribute post_id
  #   Идентификатор публикации
  #
  #   @validation Обязателен для заполнения
  #   @validation Соответствует существующей публикации
  #   @return [Integer]
  integer :post_id

  # @return [Array<Component>]
  def execute
    compose(GetPost, post_id: post_id).components.to_a
  end
end