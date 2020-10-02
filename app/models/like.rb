class Like < ApplicationRecord
  belongs_to :application
  belongs_to :admin, class_name: 'User'

  validates :evaluation, presence: true

  enum evaluation: %i[like dislike]
end
