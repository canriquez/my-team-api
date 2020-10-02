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

  def self.only_admin
    "Sorry, you need 'admin' rights to access this resource"
  end

  def self.only_admin_or_owner
    "Sorry, only 'owner' or 'admin' can execute this action"
  end

  def self.only_admin_and_owner
    "Sorry, only 'owner' and 'admin' role can execute this action"
  end


  def self.jobpost_created
    "Success!. New Jobpost created."
  end

  def self.application_created 
    "Success!. You have applied for the Job."
  end

  def self.like 
    "+1"
  end
  def self.dislike 
    "-1"
  end
end
