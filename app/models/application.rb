class Application < ApplicationRecord
  belongs_to :jobpost
  belongs_to :applicant, class_name: 'User'
  has_many :likes, dependent: :destroy

  validates :enabled, presence: true

  scope :enabled_job_post, -> { where(jobpost: Jobpost.enabled)}
  scope :disabled_job_post, -> { where(jobpost: Jobpost.disabled)}


end
