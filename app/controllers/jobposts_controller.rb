class JobpostsController < ApplicationController
    #skip_before_action :authorize_request, only: :create
    before_action :authorised_user, only: %i[index show create update]

    before_action :authorised_update, only: %i[update destroy]
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

    # create |  PUT /users/:id

    def update
        if @jobpost.update(jobpost_params) # if we succeed to update
            response = { message: 'successfull request', jobpost: @jobpost}
            json_response(response)
        else
            response = { message: 'error updating'}
            json_response(response)
        end
    end

    def destroy
        puts ' ----------- We get to destroy ------------'
        @jobpost.destroy
        response = { message: 'successfull destroy request', jobpost: @jobpost}
        json_response(response)
    end


    private

    def authorised_user
        return if current_user['role'] == 'admin'
        response = {message: Message.only_admin}
        json_response(response, :unauthorized)
    end

    def authorised_update
        @jobpost = Jobpost.find(params[:id])
        puts "Post author id : #{@jobpost['author_id']}"
        puts "current_user id is : #{current_user['id']}"
        return if current_user['id'] == @jobpost['author_id'] 
        response = {message: Message.unauthorized}
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
