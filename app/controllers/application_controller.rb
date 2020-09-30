class ApplicationController < ActionController::API
    include Response
    include ExceptionHandler


    # before action to every action in controllers
    before_action :authorize_request
    # builds the :current_user to be shared within controllers 
    attr_reader :current_user

    private

    #check valid tocken and returns user

    def authorize_request
        @current_user = (AuthorizeApiRequest.new(request.headers).call[:user])
    end
end
