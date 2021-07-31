# Булево значение компонента
class BooleanValue < ApplicationRecord
  include ComponentValue

  # @!attribute value
  #   Булево значение компонента
  #
  #   @return [NilClass, TrueClass, FalseClass]

  # @!attribute draft_value
  #   Черновое булево значение компонента.
  #   Предназначено для сохранения промежуточного непубличного состояния.
  #
  #   @return [NilClass, TrueClass, FalseClass]

  validates_inclusion_of :value, :draft_value, in: [true, false], allow_nil: true

end
