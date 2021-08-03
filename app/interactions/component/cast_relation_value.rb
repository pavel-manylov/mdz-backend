# Валидирует значение-вложения и возвращает новый (несохранённый) объект RelationValue
#
# @api private
class CastRelationValue < ActiveInteraction::Base
  array :value do
    hash do
      integer :id
    end
  end

  def execute
    if posts.count != ids.size
      errors.add :value, 'Unknown reference'
      return
    end

    RelationValue.new posts: posts
  end

  private

  def ids
    @references_ids ||= value.map { |post_reference| post_reference['id'] }.compact
  end

  def posts
    Post.where id: ids
  end
end