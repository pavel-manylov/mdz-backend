# Текстовое (строковое) значение компонента
class StringValue < ApplicationRecord
  include ComponentValue

  # @!attribute value
  #   Постоянное строковое значение компонента. Поддерживаются длинные тексты.
  #
  #   @return [String]

  # @!attribute draft_value
  #   Черновое строковое значение компонента. Поддерживаются длинные тексты.
  #
  #   @return [String]
end
