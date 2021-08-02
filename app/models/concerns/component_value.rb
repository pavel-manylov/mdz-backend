# Общее поведение для всех значений компонентов
module ComponentValue
  extend ActiveSupport::Concern

  included do
    # @!attribute component
    #   Родительский компонент, к которому относится данное значение
    #
    #   @return [Component]
    has_one :component, as: :value
  end
end