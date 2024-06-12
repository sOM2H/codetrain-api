class Api::V1::LanguagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_language, only: [:show, :update, :destroy]

  def index
    render json: Language.all
  end

  def show
    render json: @language
  end

  def create
    language = Language.new(language_params)
    if language.save
      render json: language, status: :created
    else
      render json: language.errors, status: :unprocessable_entity
    end
  end

  def update
    if @language.update(language_params)
      render json: @language
    else
      render json: @language.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @language.destroy
    head :no_content
  end

  private

  def set_language
    @language = Language.find(params[:id])
  end

  def language_params
    params.require(:language).permit(:name, :css_name, :compiler, :placeholder)
  end
end
