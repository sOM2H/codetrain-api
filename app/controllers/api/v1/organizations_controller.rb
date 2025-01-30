class Api::V1::OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :update, :destroy, 
                                          :teachers, :students, :contests ]

  def index
    render json: Organization.all
  end

  def show
    render json: @organization
  end

  def teachers
    render json: @organization.teachers, each_serializer: UserSerializer
  end

  def students
    render json: @organization.students, each_serializer: UserSerializer
  end

  def contests
    render json: @organization.contests, each_serializer: ContestSerializer
  end

  def create
    organization = Organization.new(organization_params)
    if organization.save
      render json: organization, status: :created
    else
      render json: organization.errors, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    head :no_content
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
