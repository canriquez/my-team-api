class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token =
      AuthenticateUser.new(
        auth_params[:email],
        auth_params[:password]
      ).call

    @user = if auth_token
              User.basic_info(auth_params[:email])
            else
              {}
            end

    # It Generates a session cookie with indefinite duration until logout
    new_session = RefreshToken.create(user_id: @user)
    refresh_token = new_session.crypted_token 
    cookies.signed[:session] = {
      value:refresh_token, 
      httponly: true,
      same_site: :none }
    json_response(auth_token: auth_token, user: @user)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
