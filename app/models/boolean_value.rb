# Булево значение компонента
class BooleanValue < ApplicationRecord
  include ComponentValue

  # @!attribute value
  #   Булево значение компонента
  #
  #   @return [NilClass, TrueClass, FalseClass]

  validates_inclusion_of :value, in: [true, false], allow_nil: true

end
