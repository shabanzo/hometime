# frozen_string_literal: true

module Reservations
  module Payload
    module Converter
      # The service class for converting AirBNB payload
      class Airbnb < Base
        private def convert_payload(payload)
          payload[:code] = payload.delete :reservation_code
          payload[:guest_attributes] = payload.delete :guest

          Success(payload)
        end
      end
    end
  end
end
