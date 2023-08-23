# frozen_string_literal: true

# This module for namespacing reservation-related services
# And to store common methods related to Reservation that will be reused
module Reservations
  def find_reservation(code)
    reservation = Reservation.find_by(code: code)

    Success(reservation)
  end

  def update_reservation(reservation, payload)
    if reservation.update(payload.except(:guest_attributes))
      Success(reservation.reload)
    else
      Failure(
        errors: reservation.errors.full_messages.join(', '),
        status: :unprocessable_entity
      )
    end
  end

  def create_reservation(payload)
    reservation = Reservation.new(payload)

    if reservation.save
      Success(reservation)
    else
      Failure(
        errors: reservation.errors.full_messages.join(', '),
        status: :unprocessable_entity
      )
    end
  end
end
