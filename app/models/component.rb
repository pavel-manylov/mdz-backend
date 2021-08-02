# Компонент публикации
class Component < ApplicationRecord
  # @!attribute post
  #   Пост (публикация), к которой относится данный компонент
  #
  #   @validation Обязателен для заполнения
  #   @return [Post]

  belongs_to :post

  # @!attribute value
  #   Объект-значение для данного компонента.
  #   Позволяет выставлять значения различного типа.
  #
  #   При удалении компонента так же удаляется связанное значение компонента.
  #
  #   @example component.value = BooleanValue.new(value: true)
  #   @validation Обязателен для заполнения
  #   @return [BooleanValue]

  belongs_to :value, polymorphic: true, dependent: :destroy

  # Классы, объекты которых допустимы для выставления в качестве значения #value
  ALLOWED_VALUE_CLASSES = [BooleanValue, StringValue, RelationValue]

  validate do |record|
    next if record.nil?
    record.errors.add(:value, :unsupported_class) unless record.value.class.in?(ALLOWED_VALUE_CLASSES)
  end

  # @!attribute custom_fields
  #   Настраиваемые (кастомные) поля компонента
  #
  #   @return [ActiveRecord::Relation<CustomField>]
  has_many :custom_fields

  # @!attribute public
  #   Является ли компонент публичным (должны ли предоставляться сведения о данном компоненте в публичных API )
  #
  #   @validate  Обязателен для заполнения
  #   @return [TrueClass, FalseClass]

  # @!attribute display_class
  #   Класс для отображения на клиентской стороне.
  #   Например, может напрямую соответствовать CSS классу для отображения на web-странице
  #
  #   Пустые значения автоматически сбрасываются до `nil` перед валидацией
  #
  #   @example  'headline'
  #   @example  'MDZHeadline1'
  #   @return [String, NilClass]

  # @!attribute order
  #   Порядок отображения данного компонента относительно других компонентов (0 = самый первый компонент в списке)
  #
  #   @validate Обязателен для заполнения
  #   @validate Только положительные целые числа или 0
  #   @return [Integer]

  validates_inclusion_of :public, in: [true, false]
  validates_numericality_of :order, greater_than_or_equal_to: 0, only_integer: true

  before_validation do
    self.display_class = nil if self.display_class.blank?
  end
end
