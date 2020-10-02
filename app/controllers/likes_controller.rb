class LikesController < ApplicationController
    before_action :admin_role_required, only: %i[index create]

    # it shows application index for all job applications
    def index
        @likes = Like.all
        json_response(@likes)
    end

    def create
        @like = Like.create!(like_params)
        puts 'this is new like'
        p @like
        response = { message: Message.like }
        json_response(response, :created)
    end

    private

    def like_params
        params.permit(
          :application_id,
          :admin_id,
          :evaluation
        )
    end

    def admin_role_required 
        return if current_user['role'] == 'admin'
        response = {message: Message.only_admin}
        json_response(response, :unauthorized)
    end
end
