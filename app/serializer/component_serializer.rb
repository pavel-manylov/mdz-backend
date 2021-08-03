# Сериализатор компонента
class ComponentSerializer
  class << self
    # Сериализует компонент
    # Ключи в сериализованном значении:
    #
    #   - id      — идентификатор
    #   - post_id — идентификатор публикации
    #   - public    — является ли компонент публичным
    #   - display_class — класс для отображения на клиентской стороне
    #   - order — порядковый номер компонента в публикации
    #   - custom_fields — настраиваемые поля (Hash)
    #   - type — тип значения ("string", "boolean", "relation")
    #   - value — значение (String, TrueClass|FalseClass, Array<Hash{"post_id" => Integer}>)
    #
    # @param  [Component]  component
    # @return [Hash]
    def serialize(component)
      result = component.as_json only: %w(id public display_class order post_id)
      result['custom_fields'] = custom_fields(component)
      result['type'], result['value'] = type_and_value(component)
      result
    end

    private

    # Сериализация настраиваемых полей в словарь
    #
    # @return [Hash]
    def custom_fields(component)
      component.custom_fields.inject({}) do |result, field|
        result[field.name] = field.value
        result
      end
    end

    # Тип и значение значения компонента
    #
    # @param [Component] component
    # @return [Array{String|NilClass, String|TrueClass|FalseClass|Array}]
    def type_and_value(component)
      case component.value
      when BooleanValue
        ['boolean', component.representative_value]
      when StringValue
        ['string', component.representative_value]
      when RelationValue
        ['relation', relation_value(component)]
      else
        [nil, nil]
      end
    end

    # Сериализация значения-вложений
    #
    # @param  [Component] component
    # @return [Array<Hash{"post_id" => Integer}>]
    def relation_value(component)
      component.representative_value.map do |post|
        { 'post_id' => post.id }
      end
    end
  end
end