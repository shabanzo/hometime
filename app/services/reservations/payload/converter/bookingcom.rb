# frozen_string_literal: true

module Reservations
  module Payload
    module Converter
      # The service class for converting Booking.com payload
      class Bookingcom < Base
        private def convert_payload(payload)
          Success(
            {
              code:             payload[:reservation][:code],
              start_date:       payload[:reservation][:start_date],
              end_date:         payload[:reservation][:end_date],
              nights:           payload[:reservation][:nights],
              guests:           payload[:reservation][:number_of_guests],
              adults:           payload[:reservation][:guest_details][:number_of_adults],
              children:         payload[:reservation][:guest_details][:number_of_children],
              infants:          payload[:reservation][:guest_details][:number_of_infants],
              status:           payload[:reservation][:status_type],
              guest_attributes: {
                first_name: payload[:reservation][:guest_first_name],
                last_name:  payload[:reservation][:guest_last_name],
                phone:      payload[:reservation][:guest_phone_numbers].first,
                email:      payload[:reservation][:guest_email]
              },
              currency:         payload[:reservation][:host_currency],
              payout_price:     payload[:reservation][:expected_payout_amount],
              security_price:   payload[:reservation][:listing_security_price_accurate],
              total_price:      payload[:reservation][:total_paid_amount_accurate]
            }
          )
        end
      end
    end
  end
end
