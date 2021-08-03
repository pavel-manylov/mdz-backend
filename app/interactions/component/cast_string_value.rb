# Валидирует строковое значение и возвращает новый (несохранённый) объект StringValue
#
# @api private
class CastStringValue < ActiveInteraction::Base
  string :value

  def execute
    StringValue.new(value: value)
  end
end