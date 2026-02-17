class BookingSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :user_id, :status, :service_title, :user_email

  def service_title
    object.service&.title
  end

  def user_email
    object.user&.email
  end
end
