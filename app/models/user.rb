class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  has_many :authored_posts, foreign_key: 'author_id', class_name: 'Jobpost', dependent: :destroy
  has_many :liked_applications, foreign_key: 'admin_id', class_name: 'Like', dependent: :destroy
  has_many :applications, foreign_key: 'applicant_id', class_name: 'Application', dependent: :destroy
  has_many :applied_jobs, through: :applications, source: :jobpost, dependent: :destroy

  has_many :job_posts, through: :authored_posts, source: :author

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX, message: 'The email is not valid' }
  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :avatar, presence: true,
                     length: { maximum: 100 }

  enum role: %i[user admin]

  validates :role, presence: true

  scope :user, -> { where(role: 'user')}
  scope :admin, -> { where(role: 'admin')}
  #basic info method to respond on successfull user authentication
  
  def self.basic_info(email)
    User.select("
      users.id, 
      users.email, 
      users.name, 
      users.role, 
      users.name, 
      users.updated_at
      ")
      .where(email: [email])
  end

  def self.admin_home_page_report
    User.select("users.id as applicant_id, 
      users.name as applicant_name, jobposts.name as job_name, jobposts.id as job_id, 
      jobposts.author_id, post_author.name as jobpost_author, jobposts.created_at as jobpost_date, 
      applications.id as application_id, applications.created_at as aplication_date, likes.evaluation, 
      likes.admin_id, evaluators.name as evaluator_name")
      .joins(:applied_jobs)
      .joins("INNER JOIN jobposts on jobposts.id = applications.jobpost_id")
      .joins("INNER JOIN users AS post_author ON post_author.id = jobposts.author_id")
      .joins("LEFT JOIN likes on likes.application_id = applications.id")
      .joins("LEFT JOIN users AS evaluators ON evaluators.id = likes.admin_id")
  end


end
