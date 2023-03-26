class ReservationsController < ApplicationController

  def create
    # Payload Manager
    begin
    payload = PayloadManager.build(params)
    guest = Guest.where(email: payload.guest_email).first_or_initialize
    # Check if Guest Created/Updated
    if guest.update(payload.guest_params)
    reservation = guest.reservations.where(reservation_code: payload.reservation_params[:reservation_code]).first_or_initialize
    # Check if Reservation Created/Updated
      if reservation.update(payload.reservation_params)
        render json: reservation, status: :created
      else
        render json: { errors: reservation.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: guest.errors }, status: :unprocessable_entity
    end
    rescue => e
      render json: {errors: e}, status: :unprocessable_entity
    end
  end

end