# frozen_string_literal: true

module Reservations
  # The service class for updating or inserting the reservation data
  class Update < ApplicationService
    include Reservations
    include Guests

    def call(reservation:, payload:)
      reservation = yield update_reservation(reservation, payload)
      _guest = yield update_guest(reservation.guest, payload[:guest_attributes])

      Success(reservation)
    end
  end
end
