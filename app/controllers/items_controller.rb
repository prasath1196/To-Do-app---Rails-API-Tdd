class ItemsController < ApplicationController
  include Response
  include ExceptionHandler
  before_action :set_todo
  before_action :set_todo_item, only: [:update,:destroy]
  def index
    json_response(@todo.items)
  end

  def show
    @item =  @todo.items.find(params[:id])
    json_response(@item)
  end

  def create
    @item = @todo.items.create!(item_params)
    json_response(@item,:created)
  end

  def update
    @item.update(item_params)
  end

  def destroy
    @item.destroy
  end

  private

  def set_todo
    @todo =  Todo.find(params[:todo_id])
  end

  def item_params
    params.permit(:name,:done)
  end

  def set_todo_item
    @item = @todo.items.find_by!(id: params[:id]) if @todo
  end
end
