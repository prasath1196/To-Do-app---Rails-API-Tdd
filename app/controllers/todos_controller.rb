class TodosController < ApplicationController
  include Response
  include ExceptionHandler
  before_action :set_todo, only: [:show, :update, :destroy]

  def index
    @todos =  Todo.all
    json_response(@todos)
  end

  def show
    json_response(@todo)
  end

  def create
    @todo = Todo.create!(todo_params)
    json_response(@todo,:created)
  end

  def update
    @todo =  Todo.update(todo_params)
    head :no_content
  end

  def destroy
    @todo.destroy
    head :no_content
  end

  private
  def set_todo
    @todo =  Todo.find(params[:id])
  end
  def todo_params
    # whitelist params
    params.permit(:title, :created_by)
  end

end
