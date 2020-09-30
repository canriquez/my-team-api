class UsersController < ApplicationController


    #create |  POST /signup

    def index
        @users = User.all 
        json_response(@users)
    end

    def create
        user = User.create!(user_params)
        auth_token = AuthenticateUser.new(user.email, user.password).call
        response = { message: Message.account_created, auth_token: auth_token }
        json_response(response, :created)
    end



    private

    def user_params
        params.permit(
            :email,
            :name,
            :role,
            :avatar,
            :password
        )
    end

end
