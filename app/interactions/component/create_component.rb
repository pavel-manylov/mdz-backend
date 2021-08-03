# Сервисный класс создания компонента
#
# @example
#
#   outcome = CreateComponent.run public: "true",
#                                 type: "relation",
#                                 value: [{"id" => 123}],
#                                 order: 0,
#                                 post_id: 12,
#                                 custom_fields: {"preview" => "lorem imsum"}
#   outcome.errors.to_a # => [] or ["Some error #1"]
#   outcome.result # => Component (может быть несохранённым при ошибках)
#
class CreateComponent < ActiveInteraction::Base

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

  # Создаёт компонент
  #
  # @return [Component]
  def execute
    component = Component.create post: compose(GetPost, post_id: post_id),
                                 order: order,
                                 public: public,
                                 display_class: display_class,
                                 value: compose(TYPE_TO_CAST_CLASS[type], value: value),
                                 custom_fields: build_custom_fields
    errors.merge! component.errors
    component
  end

  private

  def build_custom_fields
    custom_fields.map do |key, value|
      CustomField.new name: key, value: value
    end
  end

  # Валидирует булево значение и возвращает новый (несохранённый) объект BooleanValue
  #
  # @api private
  class CastBooleanValue < ActiveInteraction::Base
    boolean :value

    def execute
      BooleanValue.new(value: value)
    end
  end

  # Валидирует строковое значение и возвращает новый (несохранённый) объект StringValue
  #
  # @api private
  class CastStringValue < ActiveInteraction::Base
    string :value

    def execute
      StringValue.new(value: value)
    end
  end

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

  TYPE_TO_CAST_CLASS = { 'boolean' => CastBooleanValue, 'string' => CastStringValue, 'relation' => CastRelationValue }
end