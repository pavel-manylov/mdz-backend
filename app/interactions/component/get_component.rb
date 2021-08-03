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