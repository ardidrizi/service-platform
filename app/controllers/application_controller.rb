require "pundit"

class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :handle_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  def not_found
    flash[:alert] = "Page not found."
    redirect_to root_path
  end

  private

  def handle_not_authorized(exception)
    return user_not_authorized unless api_request?

    render json: { error: "Forbidden" }, status: :forbidden
  end

  def handle_record_not_found(exception)
    raise exception unless api_request?

    render json: { error: "Not Found" }, status: :not_found
  end

  def handle_record_invalid(exception)
    raise exception unless api_request?

    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || rails_health_check_path)
  end

  def api_request?
    controller_path.start_with?("api/")
  end
end
