class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token =
      AuthenticateUser.new(
        auth_params[:email],
        auth_params[:password]
      ).call

    if auth_token 
        @user = User.basic_info(auth_params[:email])
    elsif 
        @user = {}
    end 

    json_response(auth_token: auth_token, user: @user)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
