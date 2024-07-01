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

    problems = problems.page(params[:page]).per(20)

    render json: problems, each_serializer: ProblemSerializer, meta: pagination_dict(problems)
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
    attempts = @problem.attempts.where(user: current_user).order(id: :desc)

    attempts = attempts.page(params[:page]).per(20)

    render json: attempts, include: :language, each_serializer: AttemptSerializer, meta: pagination_dict(attempts)
  end

  private

  def set_problem
    @problem = Problem.includes(:tags).find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:name, :description, tag_ids: [])
  end

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page || -1,
      prev_page: collection.prev_page || -1,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
