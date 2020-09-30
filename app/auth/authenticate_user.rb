class AuthenticateUser

    def initialize(email, password)
        @email = email
        @password = password
    end

    # entry point method

    def call
        JsonWebToken.encode(User_id: user.id) if user
    end

    private

    attr_reader :email, :password


    def user
        user = User.find_by(email: email)
        return user if user && user.authenticate(password)

        #raise Authentication error if credentials are wrong

        raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
    end

end