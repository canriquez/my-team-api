class JsonWebToken
    #defines encoding secret - this could be a text though

    SECRET = Rails.application.secrets.secret_key_base

    def self.encode(payload, exp = 24.hours.from_now)
        payload[:exp] = exp.to_i
        #encodes payload using Rails secret keybase
        JWT.encode(payload, SECRET)
    end

    def self.decode(token)

        body = JWT.decode(token, SECRET)[0]
        HashWithIndifferentAccess.new body
            
        #rescue all errors
    rescue JWT::DecodeError => e 
        #next line gets executed only in error
       raise ExceptionHandler::InvalidToken, e.message 
    end
end
