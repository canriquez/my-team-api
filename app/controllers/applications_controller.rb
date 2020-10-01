class ApplicationsController < ApplicationController

    before_action :authorised_user, only: %i[index show]

    # it shows application index for all job applications with a enabled jobpost scope
    def index
        @applications = Application.enabled_job_post
        json_response(@applications)
    end

    def show
        @application = Application.find(params[:id])
        response = { message: 'successfull request', application: @application}
        json_response(response)
      end


    private

    def authorised_user

        @application = Application.find(params[:id])
        puts '||||||===== CHECKING AUTHORIZATION ==== ||||||'
        puts "applicant_id #{@application.applicant_id}"
        puts "current_user id #{current_user['id']}"

        return if current_user['role'] == 'admin' || @application.applicant_id == current_user['id']
        response = {message: Message.only_admin_or_owner}
        json_response(response, :unauthorized)
    end

end
