class Api::V1::TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Tag.all
  end

  def show
    render json: Tag.find(params[:id])
  end

  def create
    tag = Tag.new(tag_params)
    if tag.save
      render json: tag, status: :created
    else
      render json: tag.errors, status: :unprocessable_entity
    end
  end

  def update
    tag = Tag.find(params[:id])
    if tag.update(tag_params)
      render json: tag
    else
      render json: tag.errors, status: :unprocessable_entity
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    head :no_content
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
