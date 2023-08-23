# frozen_string_literal: true

module Reservations
  module Payload
    # The service class for identifying the payload and return the identity of the payload
    class Identifier < Base
      def call(payload:)
        service_klass = yield identify_payload(payload)

        Success(service_klass)
      end

      private def identify_payload(payload)
        if payload['reservation']
          Success('Bookingcom')
        elsif payload['reservation_code']
          Success('Airbnb')
        else
          Failure(:not_implemented)
        end
      end
    end
  end
end
