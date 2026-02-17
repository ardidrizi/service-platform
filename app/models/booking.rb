class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :service

  enum status: { pending: 0, confirmed: 1, cancelled: 2 }

  validates :user, presence: true
  validates :service, presence: true
end
