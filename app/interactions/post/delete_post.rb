# Сервисный класс удаления публикации
class DeletePost < ActiveInteraction::Base
  # @!attribute post_id
  #   Идентификатор публикации
  #
  #   @validation Обязателен для заполнения
  #   @validation Соответствует существующей публикации
  #   @return [Integer]
  integer :post_id

  # Удаляет публикацию
  #
  # @return [TrueClass]
  def execute
    compose(GetPost, post_id: post_id).destroy
    true
  end
end