class LikesController < ApplicationController
    before_action :admin_role_required, only: %i[index create]
    before_action :authorised_user, only: %i[destroy update]
    before_action :verify_creator_authorization, only: :create

    # it shows application index for all job applications
    def index
        @likes = Like.all
        json_response(@likes)
    end

    def create
        @like = Like.create!(like_params)
        puts '|||||||||||||||||||||||||| CREATE ||||||||||||||||||||'
        p @like
        p like_params
        puts 'update action'
        p @like.update!(like_params)
        puts '-------------------------------------------------------'
        if like_params['evaluation'] == 'like'
            response = { message: Message.like }
        elsif
            response = { message: Message.dislike }
        end
        json_response(response, :created)
    end

    def update
        puts '|||||||||||||||||||||||||| UPDATE ||||||||||||||||||||'
        p @like
        p like_params
        puts 'update action'
        p @like.update!(like_params)
        puts '-------------------------------------------------------'
        if @like.update(like_params) # if we succeed to update
            response = { message: 'successfull update request', like: @like}
            json_response(response)
        else
            response = { message: 'error updating'}
            json_response(response)
        end
    end

    def destroy
        puts ' ----------- We get to destroy like applications ------------'
        @like.destroy
        response = { message: 'like destroyed', like: @like}
        json_response(response)
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
        puts '||||||===== CHECKING ADMIN ==== ||||||'
        #puts "like creator: admin_id #{@like.admin_id}"
        puts "current_user id #{current_user['id']}"
        puts "current user's role #{current_user['role']}" 

        return if current_user['role'] == 'admin'
        response = {message: Message.only_admin}
        json_response(response, :unauthorized)
    end

    def authorised_user
        @like = Like.find(params[:id])
        puts '||||||===== CHECKING AUTHORIZATION ==== ||||||'
        puts "like creator: admin_id #{@like.admin_id}"
        puts "current_user id #{current_user['id']}"
        puts "current user's role #{current_user['role']}"

        return if @like.admin_id == current_user['id'] && current_user['role'] == 'admin'
        response = {message: Message.only_admin_and_owner}
        json_response(response, :unauthorized)
    end

    def verify_creator_authorization
        puts '||||||===== CHECKING CREATOR AUTHORIZATION ==== ||||||'
        puts "current_user id #{current_user['id']}"
        puts "New Liked record admin_id #{like_params['admin_id']}"
        return if current_user['id'] == like_params['admin_id']
    end

end
