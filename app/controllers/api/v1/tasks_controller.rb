class Api::V1::TasksController < ApplicationController

  before_action :find_task, only: %i(update destroy)

  def index
    render json: Task.all
  end

  def create
    @task = Task.new
    if @task.update_attributes(task_params)
      render json: @task, status: 201
    else
      render json: {errors: @task.errors}, status: 400
    end
  end

  def update
    if @task.update_attributes(task_params)
      render json: @task
    else
      render json: {errors: @task.errors}, status: 400
    end
  end

  def destroy
    @task.destroy
    head 204
  end

  private

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    ActiveModelSerializers::Deserialization.jsonapi_parse!(params, only: [:title, :tags])
  end

end
