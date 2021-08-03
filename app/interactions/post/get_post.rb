# Получение публикации по идентификатору
class GetPost < ActiveInteraction::Base
  # @!attribute post_id
  #   Идентификатор публикации
  #
  #   @validation Обязателен для заполнения
  #   @validation Соответствует существующей публикации
  #   @return [Integer]
  integer :post_id

  def execute
    post = Post.find_by_id post_id
    errors.add(:post_id, I18n.t('interaction.errors.post_not_found')) unless post
    post
  end
end