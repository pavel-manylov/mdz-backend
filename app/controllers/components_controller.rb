class ComponentsController < ApplicationController
  # Создаёт и возвращает новый компонент
  #
  # @example {include:file:../http/components/create.http}
  def create
    create_params = params.permit(:post_id, :public, :display_class,
                                     :order, :type, custom_fields: {}).to_h
    create_params[:value] = params[:value]

    component = CreateComponent.run! create_params
    render json: ComponentSerializer.serialize(component)
  end
end