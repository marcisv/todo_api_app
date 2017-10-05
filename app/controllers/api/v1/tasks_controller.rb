class Api::V1::TasksController < ApplicationController

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
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      render json: @task
    else
      render json: {errors: @task.errors}, status: 400
    end
  end

  private

  def task_params
    ActiveModelSerializers::Deserialization.jsonapi_parse!(params, only: [:title, :tags])
  end

end
