class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :service

  enum status: { pending: 0, confirmed: 1, cancelled: 2 }

  validates :user, presence: true
  validates :service, presence: true
  validate :service_cannot_be_owned_by_user

  private

  def service_cannot_be_owned_by_user
    return unless user && service && service.user == user

    errors.add(:base, "You cannot book your own service")
  end
end
