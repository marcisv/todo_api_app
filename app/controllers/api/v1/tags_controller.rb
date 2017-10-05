class Api::V1::TagsController < ApplicationController

  def index
    render json: Tag.all
  end

  def create
    @tag = Tag.new
    if @tag.update_attributes(tag_params)
      render json: @tag, status: 201
    else
      render json: {errors: @tag.errors}, status: 400
    end
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(tag_params)
      render json: @tag
    else
      render json: {errors: @tag.errors}, status: 400
    end
  end

  private

  def tag_params
    ActiveModelSerializers::Deserialization.jsonapi_parse!(params, only: [:title])
  end

end
