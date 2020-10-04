class Like < ApplicationRecord
  belongs_to :application
  belongs_to :admin, class_name: 'User'

  validates :evaluation, presence: true

  enum evaluation: %i[like dislike]

  validates :application_id, :uniqueness => { :scope => :admin_id,
                                              :message => "should have only one like/dislike record per :admin user." }
end
