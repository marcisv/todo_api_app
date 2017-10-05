class Api::V1::TasksController < ApplicationController

  def index
    render json: Task.all
  end

end
