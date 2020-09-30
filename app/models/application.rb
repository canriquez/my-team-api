class Application < ApplicationRecord
  belongs_to :jobpost
  belongs_to :applicant, class_name: 'User'
  has_many :likes, dependent: :destroy

  validates :enable, presence: true
end
