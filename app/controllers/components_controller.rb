class ComponentsController < ApplicationController
  # Список компонентов публикации
  #
  # @example {include:file:../http/components/index.http}
  def index
    components = IndexComponents.run! params.permit(:post_id).to_h
    render json: ComponentSerializer.serialize(components)
  end

  # Создаёт и возвращает новый компонент
  #
  # @example {include:file:../http/components/create.http}
  def create
    component = CreateComponent.run! component_params
    render json: ComponentSerializer.serialize(component)
  end

  # Обновляет указанный компонент
  #
  # @example {include:file:../http/components/update.http}
  def update
    update_params = component_params
    update_params[:component_id] = params[:id]

    component = UpdateComponent.run! update_params

    render json: ComponentSerializer.serialize(component)
  end

  # Удаляет указанный компонент
  #
  # @example {include:file:../http/components/delete.http}
  def destroy
    DeleteComponent.run! component_id: params[:id]
    render json: {}
  end

  private

  def component_params
    result = params.permit(:post_id, :public, :display_class,
                           :order, :type, custom_fields: {}).to_h
    result[:value] = params[:value]
    result
  end
end