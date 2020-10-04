class Application < ApplicationRecord
  belongs_to :jobpost
  belongs_to :applicant, class_name: 'User'
  has_many :likes, dependent: :destroy

  scope :enabled_job_post, -> { where(jobpost: Jobpost.enabled) }
  scope :disabled_job_post, -> { where(jobpost: Jobpost.disabled) }

  # validation to avoide same multiple applications to same  job.

  validates :applicant_id, uniqueness: { scope: :jobpost }
end
