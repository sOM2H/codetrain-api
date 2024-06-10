class Api::V1::ProblemsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Problem.includes(:tags).all
  end

  def show
    render json: Problem.includes(:tags).find(params[:id])
  end

  def create
    problem = Problem.new(problem_params)
    if problem.save
      render json: problem, status: :created
    else
      render json: problem.errors, status: :unprocessable_entity
    end
  end

  def update
    problem = Problem.find(params[:id])
    if problem.update(problem_params)
      render json: problem
    else
      render json: problem.errors, status: :unprocessable_entity
    end
  end

  def destroy
    problem = Problem.find(params[:id])
    problem.destroy
    head :no_content
  end

  private

  def problem_params
    params.require(:problem).permit(:name, :description, :average_rating, tag_ids: [])
  end
end
