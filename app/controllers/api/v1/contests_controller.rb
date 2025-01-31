class Api::V1::ContestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contest, only: [:show, :problems, :results]

  def index
    contests = current_user.organization.contests
    render json: contests, each_serializer: ContestSerializer
  end

  def show
    if authorized_user?
      render json: @contest, serializer: ContestSerializer
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  def problems
    if authorized_user?
      render json: @contest.problems.order(id: 'asc'), each_serializer: ProblemSerializer, current_user: current_user, contest_id: @contest.id
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  def results
    if authorized_user?
      render json: @contest, serializer: ContestResultsSerializer
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  private

  def set_contest
    @contest = Contest.find(params[:id])
  end

  def authorized_user?
    current_user.organization == @contest.organization
  end
end
