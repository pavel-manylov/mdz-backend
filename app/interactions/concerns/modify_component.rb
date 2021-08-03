module ModifyComponent
  extend ActiveSupport::Concern

  included do
    # @!attribute public
    #   Является дли данный компонент публичным?
    #
    #   @validation Обязателен для заполнения
    #   @return [Boolean]
    boolean :public

    # @!attribute order
    #   Порядковый номер компонента в публикации (0=самый первый)
    #
    #   @validation Обязателен для заполнения
    #   @return [Integer]
    integer :order

    # @!attribute post_id
    #   Идентификатор публикации, к которой относится данный компонент
    #
    #   @validation Обязателен для заполнения
    #   @validation Публикация должна существовать
    #   @return [Integer]
    integer :post_id

    # @!attribute type
    #   Тип значения компонента
    #
    #   @validation Обязателен для заполнения
    #   @validation Одно из значений: `"string"`, `"boolean"`, `"relation"`
    #   @return [String]
    string :type

    validates_inclusion_of :type, in: %w(boolean string relation)

    # @!attribute display_class
    #   Класс для отображения на клиентской стороне
    #
    #   @return [String]
    string :display_class, default: nil

    # @!attribute value
    #   Значение компонента
    #
    #   Для значения типа `type = "relation"` значение указывается в формате: `[{"id" => 123}]`,
    #   где 123 — идентификатор публикации
    #
    #   @validation Обязателен для заполнения
    #   @validation Тип и формат соответствует типу значения компонента {#type}
    #   @validation Все указанные публикации существуют (только для типа `"relation"`)
    #   @return [Boolean, String, Array<Hash{id: Integer}>]
    object :value, class: Object

    # @!attribute custom_fields
    #   Настраиваемые поля компонента
    #
    #   @example { 'ios-class' => 'xLarge', 'preview-text' => 'Lorem ipsum…' }
    #   @validation  Ключи и значения не могут быть пустыми
    #   @return [Hash]
    object :custom_fields, class: Hash
  end

  TYPE_TO_CAST_CLASS = { 'boolean' => CastBooleanValue, 'string' => CastStringValue, 'relation' => CastRelationValue }

  private

  def custom_fields_attributes
    custom_fields.map do |name, value|
      { name: name, value: value }
    end
  end
end