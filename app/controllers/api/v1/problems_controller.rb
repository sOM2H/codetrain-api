class Api::V1::ProblemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_problem, only: [:show, :update, :destroy, :attempts]

  ALLOWED_SORT_FIELDS = %w[title complexity status created_at].freeze
  ALLOWED_SORT_ORDERS = %w[asc desc].freeze

  def index
    problems = Problem.includes(:tags)

    if params[:sort_by].present? && ALLOWED_SORT_FIELDS.include?(params[:sort_by]) &&
       params[:sort_order].present? && ALLOWED_SORT_ORDERS.include?(params[:sort_order])
      problems = problems.order(params[:sort_by] => params[:sort_order])
    end

    if params[:tag_ids].present?
      tag_ids = params[:tag_ids].split(',').map(&:to_i)
      problems = problems.joins(:tags).where(tags: { id: tag_ids }).distinct
    end

    problems = problems.page(params[:page]).per(20)

    render json: problems, each_serializer: ProblemSerializer, meta: pagination_dict(problems), current_user: current_user
  end

  def show
    render json: @problem, serializer: ProblemSerializer, current_user: current_user
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
    if @problem.destroy
      head :no_content
    else
      render json: @problem.errors, status: :unprocessable_entity
    end
  end

  def attempts 
    attempts = @problem.attempts.where(user: current_user, contest_id: params[:contest_id]).order(id: :desc)

    if attempts.any?
      attempts = attempts.page(params[:page]).per(20)
      render json: attempts, include: :language, each_serializer: AttemptSerializer, meta: pagination_dict(attempts)
    else
      render json: { message: "No attempts found" }, status: :ok
    end
  end

  private

  def set_problem
    @problem = Problem.includes(:tags).find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:title, :description, tag_ids: [])
  end

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end