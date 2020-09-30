class Like < ApplicationRecord
  belongs_to :application
  belongs_to :admin, class_name: 'User'

  validates :type, presence: true

end
