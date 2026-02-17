class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: %i[show edit update destroy]

  after_action :verify_policy_scoped, only: :index
  after_action :verify_authorized, except: :index

  def index
    @bookings = policy_scope(Booking)
  end

  def show
    authorize(@booking)
  end

  def new
    @booking = current_user.bookings.build
    authorize(@booking)
  end

  def create
    @booking = current_user.bookings.build(booking_params)
    authorize(@booking)

    if @booking.save
      redirect_to @booking, notice: "Booking created."
    else
      flash.now[:alert] = @booking.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize(@booking)
  end

  def update
    authorize(@booking)

    if @booking.update(booking_params)
      redirect_to @booking, notice: "Booking updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize(@booking)
    @booking.destroy
    redirect_to bookings_path, notice: "Booking cancelled."
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:service_id, :status)
  end
end
