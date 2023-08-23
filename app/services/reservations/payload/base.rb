# frozen_string_literal: true

module Reservations
  module Payload
    # The base class service for Reservations::Payload
    class Base < ApplicationService
      include Reservations

      def call(payload:)
        new_payload = yield convert_payload(payload)

        Success(new_payload)
      end
    end
  end
end
