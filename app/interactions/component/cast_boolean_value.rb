# Валидирует булево значение и возвращает новый (несохранённый) объект BooleanValue
#
# @api private
class CastBooleanValue < ActiveInteraction::Base
  boolean :value

  def execute
    BooleanValue.new(value: value)
  end
end