class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
    has_many :authored_posts, foreign_key: 'author_id', class_name: 'Jobpost', dependent: :destroy
    has_many :liked_applications, foreign_key: 'admin_id', class_name: 'Like', dependent: :destroy
    has_many :applications, foreign_key: 'applicant_id', class_name: 'Application', dependent: :destroy
    #has_many :applied_jobs, through: :applications, source: :jobpost

    validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX, message: 'The email is not valid' }
    validates :name, presence: true,
                      length: {maximum: 50}

    validates :avatar, presence: true,
                      length: {maximum: 100}

    enum role: %i[user admin]

    validates :role, presence: true

end
