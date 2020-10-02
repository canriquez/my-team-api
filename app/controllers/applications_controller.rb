class ApplicationsController < ApplicationController
    before_action :admin_role_required, only: :index
    before_action :authorised_user, only: %i[show]

    # it shows application index for all job applications with a enabled jobpost scope
    def index
        @applications = Application.enabled_job_post
        json_response(@applications)
    end

    def show
        #@application = Application.find(params[:id])
        response = { message: 'successfull request', application: @application}
        json_response(response)
    end


    private

    def authorised_user
        @application = Application.find(params[:id])
        puts '||||||===== CHECKING AUTHORIZATION ==== ||||||'
        puts "applicant_id #{@application.applicant_id}"
        puts "current_user id #{current_user['id']}"
        puts "current user's role #{current_user['role']}"

        return if @application.applicant_id == current_user['id'] || current_user['role'] == 'admin'
        response = {message: Message.only_admin_or_owner}
        json_response(response, :unauthorized)
    end

    def admin_role_required 
        return if current_user['role'] == 'admin'
        response = {message: Message.only_admin}
        json_response(response, :unauthorized)
    end

end
