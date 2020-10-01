class JobpostsController < ApplicationController
    #skip_before_action :authorize_request, only: :create
    before_action :authorised_user, only: %i[index show create]
    #index

    def index
        @jobposts = current_user.authored_posts
        json_response(@jobposts)
    end


    def show
        @jobpost = Jobpost.find(params[:id])
        puts "jobposts now"
        p @jobpost
        response = { message: 'successfull request', jobpost: @jobpost }
        json_response(response)
    end

    def create
        @jobpost = Jobpost.create!(jobpost_params)
        puts 'this is new jobpost'
        p @jobpost
        response = { message: Message.jobpost_created, jobpost: @jobpost }
        json_response(response, :created)
    end

    private

    def authorised_user
        return if current_user['role'] == 'admin'
        response = {message: Message.only_admin}
        json_response(response, :unauthorized)
    end

    def jobpost_params
        params.permit(
          :id,
          :name,
          :author_id,
          :enabled,
          :image
        )
      end

end
