class ApplicationsController < ApplicationController
  before_action :authenticated_only, only: :create
  before_action :admin_role_required, only: :index
  before_action :authorised_user, only: %i[show destroy]
  before_action :admin_updates_only, only: :update

  # it shows application index for all job applications with a enabled jobpost scope
  def index
    @applications = Application.enabled_job_post
    json_response(@applications)
  end

  # author user or admin can show the application
  def show
    response = { message: 'successfull request', application: @application }
    json_response(response)
  end

  def create
    @application = Application.create!(application_params)
    response = { message: Message.application_created, application: @application }
    json_response(response, :created)
  end

  # user or admin can destroy an application
  def destroy
    @application.destroy
    response = { message: 'successfull destroy request', application: @application }
    json_response(response)
  end

  def update
    if @application.update(application_params) # if we succeed to update
      response = { message: 'successfull request', application: @application }
      json_response(response)
    else
      response = { message: 'error updating' }
      json_response(response)
    end
  end

  private

  def application_params
    params.permit(
      :applicant_id,
      :jobpost_id,
      :enabled
    )
  end

  def authenticated_only
    return if current_user

    response = { message: Message.only_admin }
    json_response(response, :unauthorized)
  end

  def admin_updates_only
    @application = Application.find(params[:id]);
    return if @application && current_user['role'] == 'admin'

    response = { message: Message.only_admin }
    json_response(response, :unauthorized)
  end

  def authorised_user
    @application = Application.find(params[:id])
    return if @application.applicant_id == current_user['id'] || current_user['role'] == 'admin'

    response = { message: Message.only_admin_or_owner }
    json_response(response, :unauthorized)
  end

  def admin_role_required
    return if current_user['role'] == 'admin'

    response = { message: Message.only_admin }
    json_response(response, :unauthorized)
  end
end
