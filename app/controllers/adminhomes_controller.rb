class AdminhomesController < ApplicationController
  skip_before_action :authorize_request, only: %i[check_sign_up_email]
  before_action :admin_role_required, only: %i[adhome getadmin_evaluations]

  # adhome

  def adhome
    # @admin_home_page = User.admin_index_report
    @admin_home_page = User.admin_full_index_report(current_user)
    json_response(@admin_home_page)
  end

  def check_sign_up_email
    puts '||||||| here in checkemail method ||||||'
    p user_params['email']
    p user_params
    @email = User.find_by_email(user_params[:email])
    p @email
    if @email
      response = { message: 'taken' }
    else
      message = "#{user_params[:email]} available"
      response = { message: message }
    end
    json_response(response)
  end

  def getadmin_evaluations
    @user = User.find(user_params[:id])
    puts 'USER IS HERE ||| ;'
    p @user
    @admin_evaluations = User.admin_evaluations(@user.id)
    json_response(@admin_evaluations)
  end

  private

  def user_params
    params.permit(
      :email,
      :id
    )
  end

  def admin_role_required
    return if current_user['role'] == 'admin'

    response = { message: Message.only_admin }
    json_response(response, :unauthorized)
  end
end
