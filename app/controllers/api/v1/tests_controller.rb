class Api::V1::TestsController < ApplicationController
  before_action :authenticate_user!

  def index
    problem = Problem.find(params[:problem_id])
    render json: problem.tests
  end

  def show
    render json: Test.find(params[:id])
  end

  def create
    test = Problem.find(params[:problem_id]).tests.build(test_params)
    if test.save
      render json: test, status: :created
    else
      render json: test.errors, status: :unprocessable_entity
    end
  end

  def update
    test = Test.find(params[:id])
    if test.update(test_params)
      render json: test
    else
      render json: test.errors, status: :unprocessable_entity
    end
  end

  def destroy
    test = Test.find(params[:id])
    test.destroy
    head :no_content
  end

  private

  def test_params
    params.require(:test).permit(:input, :output)
  end
end
