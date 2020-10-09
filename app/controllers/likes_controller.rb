class LikesController < ApplicationController
  before_action :admin_role_required, only: %i[index]
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
    puts '-------------------------------------------------------'
    response = if like_params['evaluation'] == 'like'
                 { message: Message.like, like: @like }
               else
                 { message: Message.dislike, like: @like }
               end
    json_response(response, :created)
  end

  def update
    puts '|||||||||||||||||||||||||| UPDATE ||||||||||||||||||||'
    p @like
    p like_params
    puts 'update action'
    puts '-------------------------------------------------------'
    response = if @like.update(evaluation: like_params['evaluation']) # if we succeed to update
                 { message: 'successfull update request', like: @like }
               else
                 { message: 'error updating' }
               end
    json_response(response)
  end

  def destroy
    puts ' ----------- We get to destroy like applications ------------'
    @like.destroy
    response = { message: 'like destroyed', like: @like }
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
    # puts "like creator: admin_id #{@like.admin_id}"
    puts "current_user id #{current_user['id']}"
    puts "current user's role #{current_user['role']}"

    return if current_user['role'] == 'admin'

    response = { message: Message.only_admin }
    json_response(response, :unauthorized)
  end

  def authorised_user
    @like = Like.find(params[:id])
    puts '||||||===== CHECKING AUTHORIZATION ==== ||||||'
    puts "like creator: admin_id #{@like.admin_id}"
    puts "current_user id #{current_user['id']}"
    puts "current user's role #{current_user['role']}"

    return if @like.admin_id == current_user['id'] && current_user['role'] == 'admin'

    response = { message: Message.only_admin_and_owner }
    json_response(response, :unauthorized)
  end

  def verify_creator_authorization
    puts '||||||===== CHECKING CREATOR AUTHORIZATION ==== ||||||'
    puts "current_user id #{current_user['id']}"
    puts "New Liked record admin_id #{like_params['admin_id']}"
    puts "current user's role #{current_user['role']}"
    puts "authorization : #{current_user['id'].to_i == like_params['admin_id'].to_i}"
    return if current_user['id'].to_i == like_params['admin_id'].to_i && current_user['role'] == 'admin'

    response = { message: Message.only_admin_and_owner }
    json_response(response, :unauthorized)
  end
end
