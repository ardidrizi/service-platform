module Api
  module V1
    class BookingsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_booking, only: %i[show update destroy]

      after_action :verify_policy_scoped, only: :index
      after_action :verify_authorized, except: :index

      def index
        @bookings = policy_scope(Booking)
        render json: @bookings
      end

      def show
        authorize(@booking)
        render json: @booking
      end

      def create
        @booking = current_user.bookings.build(booking_params)
        authorize(@booking)

        if @booking.save
          render json: @booking, status: :created
        else
          render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize(@booking)

        if @booking.update(booking_params)
          render json: @booking
        else
          render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize(@booking)
        @booking.destroy
        head :no_content
      end

      private

      def set_booking
        @booking = Booking.find(params[:id])
      end

      def booking_params
        params.require(:booking).permit(:service_id, :status)
      end
    end
  end
end
