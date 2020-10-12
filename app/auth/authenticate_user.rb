class AuthenticateUser
  def initialize(email, password, refresh=false)
    @email = email
    @password = password
    @refresh =  refresh  #generates a refresh HTTPonly token (longer expiration)
  end

  # entry point method

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  def call_rt
    JsonWebToken.encode({user_id: user.id}, (2.days.from_now )) if user
  end

  private

  attr_reader :email, :password

  def user
    user = User.find_by(email: email)
    return user if user&.authenticate(password)

    # raise Authentication error if credentials are wrong

    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end
