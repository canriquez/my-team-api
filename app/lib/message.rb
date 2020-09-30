class Message

    def self.not_found(record = 'record')
        "Sorry, #{record} not found."
    end

    def self.invalid_credentials
        "Invalid credentials"
    end

    def self.invalid_token
        "mmmm, token invalid, are you a hacker?"
    end

    def self.missing_token
        "Authentication Missing"
    end

    def self.unauthorized
        "Unauthorized request"
    end

    def self.account_created
        "Success! - Account has been created."
    end

    def self.account_not_created
        "Sorry, Account cannot be created."
    end

    def self.expired_token
        "Authentication expired, please login again"
    end

end
