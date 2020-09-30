class Jobpost < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :applications, dependent: :destroy
  has_many :applicants, through: :applications, source: :applicant, dependent: :destroy

  validates :image, presence: true,
                    length: { maximum: 100 }
  validates :enabled, presence: true

  validates :name, presence: true,
                   length: { maximum: 50 }
end
