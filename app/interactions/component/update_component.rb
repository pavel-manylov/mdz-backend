class UpdateComponent < ActiveInteraction::Base
  include ModifyComponent

  integer :component_id

  def execute
    component = compose(GetComponent, component_id: component_id)

    component.update order: order,
                     public: public,
                     display_class: display_class,
                     value: compose(TYPE_TO_CAST_CLASS[type], value: value),
                     custom_fields_attributes: custom_fields_attributes(component)
    errors.merge! component.errors
    component
  end

  # @api private
  class GetComponent < ActiveInteraction::Base
    integer :component_id

    # @return [NilClass, Component]
    def execute
      component = Component.find_by_id(component_id)
      errors.add(:component_id, 'Component not found') if component.nil?
      component
    end
  end

  private

  # Атрибуты отражают добавление, обновление и удаление настраиваемых полей в формате,
  # который поддерживает {Component#custom_fields_attributes=}.
  #
  # @return [Array<Hash>]
  def custom_fields_attributes(component)
    result = []
    pending_custom_fields = custom_fields.dup

    component.custom_fields.each do |custom_field|
      name = custom_field.name

      unless pending_custom_fields.has_key? name
        result << { id: custom_field.id, _destroy: true }
        next
      end

      result << { id: custom_field.id, name: name, value: pending_custom_fields[name] }
      pending_custom_fields.delete name
    end

    pending_custom_fields.each do |name, value|
      result << { name: name, value: value }
    end

    result
  end
end