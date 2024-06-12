class Api::V1::AttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attempt, only: [:show, :update, :destroy]

  def index
    @attempts = Attempt.all
    render json: @attempts
  end

  def show
    render json: @attempt
  end

  def create
    @attempt = Attempt.new(attempt_params)
    @attempt.user = current_user
    if @attempt.save
      CompileWorker.perform_async(@attempt.id) unless Rails.env.test?
      render json: @attempt, status: :created
    else
      render json: @attempt.errors, status: :unprocessable_entity
    end
  end

  def update
    if @attempt.update(attempt_params)
      render json: @attempt
    else
      render json: @attempt.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @attempt.destroy
    head :no_content
  end

  private

  def set_attempt
    @attempt = Attempt.find(params[:id])
  end

  def attempt_params
    params.require(:attempt).permit(:code, :problem_id, :language_id)
  end
end
