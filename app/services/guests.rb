# frozen_string_literal: true

# This module for namespacing reservation-related services
# And to store common methods related to Reservation that will be reused
module Guests
  def update_guest(guest, payload)
    if guest.update(payload)
      Success(guest.reload)
    else
      Failure(
        errors: guest.errors.full_messages.join(', '),
        status: :unprocessable_entity
      )
    end
  end
end
