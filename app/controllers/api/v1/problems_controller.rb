class Api::V1::ProblemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_problem, only: [:show, :update, :destroy, :attempts]

  def index
    problems = Problem.includes(:tags)

    if params[:sort_by].present? && params[:sort_order].present?
      problems = problems.order(params[:sort_by] => params[:sort_order])
    end

    if params[:tag_ids].present?
      tag_ids = params[:tag_ids].split(',')
      problems = problems.joins(:tags).where(tags: { id: tag_ids }).distinct
    end

    render json: problems
  end

  def show
    render json: @problem
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
    if @problem.update(problem_params)
      render json: @problem
    else
      render json: @problem.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @problem.destroy
    head :no_content
  end

  def attempts
    attempts = @problem.attempts.order(id: :desc)
    render json: attempts, include: :language
  end

  private

  def set_problem
    @problem = Problem.includes(:tags).find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:name, :description, :average_rating, tag_ids: [])
  end
end
