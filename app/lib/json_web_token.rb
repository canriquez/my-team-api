class JsonWebToken
  # defines encoding secret - this could be a text though

  # SECRET = Rails.application.secrets.secret_key_base
  SECRET = Rails.application.secret_key_base

  puts '|| current secret ||'
  p SECRET

  def self.encode(payload, refresh = false)
    if !refresh 
      exp = 15.minutes.from_now 
      payload[:exp] = exp.to_i
      payload[:now] = Time.zone.now
      payload[:then] = 15.minutes.from_now
      # encodes payload using Rails secret keybase
    else
      exp = 2.days.from_now 
      payload[:exp] = exp.to_i
      payload[:now] = Time.zone.now
      payload[:then] = 2.days.from_now
      # encodes payload using Rails secret keybase
    end
    return JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET)[0]
    puts '||| -- decoding --- |||'
    p body
    HashWithIndifferentAccess.new body

  # rescue all errors
  rescue JWT::DecodeError => e
    # next line gets executed only in error
    raise ExceptionHandler::InvalidToken, e.message
  end
end
