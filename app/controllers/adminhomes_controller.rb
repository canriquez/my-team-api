class AdminhomesController < ApplicationController
  skip_before_action :authorize_request, only: %i[checkSignUpEmail]
  before_action :admin_role_required, only: %i[adhome]

  # adhome

  def adhome
    @admin_home_page = User.admin_index_report
    json_response(@admin_home_page)
  end

  def checkSignUpEmail
    puts '||||||| here in checkemail method ||||||'
    p user_params['email']
    p user_params
    @email = User.find_by_email(user_params[:email])
    p @email
    if @email
      response = { message: 'taken' }
      json_response(response)
    else
      message = "#{user_params[:email]} available"
      response = { message: message }
      json_response(response)
    end
  end

  private

  def user_params
    params.permit(
      :email
    )
  end

  def admin_role_required
    return if current_user['role'] == 'admin'

    response = { message: Message.only_admin }
    json_response(response, :unauthorized)
  end
end
