class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :user_id, :user_email

  def user_email
    object.user&.email
  end
end
