class UsersController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]
  before_action :current_user_action, only: %i[update show]

  def index
    @users = User.all
    json_response(@users)
  end

  # show

  def show
    @user = User.find(params[:id])
    response = { message: 'successfull request', user: User.basic_info(@user.email) }
    json_response(response)
  end

  # create |  POST /signup

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  # create |  PUT /users/:id

  def update
    response = if @user.update(user_params) # if we succeed to update
                 { message: 'successfull request', user: User.basic_info(@user.email) }
               else
                 { message: 'error updating' }
               end
    json_response(response)
  end

  private

  def user_params
    params.permit(
      :id,
      :email,
      :name,
      :role,
      :avatar,
      :password
    )
  end

  def current_user_action
    @user = User.find(params[:id])
    puts "user request is : #{@user['id']}"
    puts "current_user is : #{current_user['id']}"
    return if current_user['id'] == @user['id']

    response = { message: Message.only_own_account }
    json_response(response, :unauthorized)
  end
end
