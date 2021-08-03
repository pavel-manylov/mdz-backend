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
  include ModifyComponent

  # Создаёт компонент
  #
  # @return [Component]
  def execute
    component = Component.create post: compose(GetPost, post_id: post_id),
                                 order: order,
                                 public: public,
                                 display_class: display_class,
                                 value: compose(TYPE_TO_CAST_CLASS[type], value: value),
                                 custom_fields_attributes: custom_fields_attributes
    errors.merge! component.errors
    component
  end
end