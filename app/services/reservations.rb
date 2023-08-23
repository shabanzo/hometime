# frozen_string_literal: true

# This module for namespacing reservation-related services
# And to store common methods that will be reused
module Reservations
  def find_reservation(code)
    reservation = Reservation.find_by(code: code)

    Success(reservation)
  end

  def update_reservation(reservation, new_payload)
    if reservation.update(new_payload)
      Success(reservation.reload)
    else
      Failure(:unprocessable_entity)
    end
  end

  def create_reservation(new_payload)
    reservation = Reservation.new(new_payload)

    if reservation.save
      Success(reservation)
    else
      Failure(:unprocessable_entity)
    end
  end
end
