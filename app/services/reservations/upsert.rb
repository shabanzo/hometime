# frozen_string_literal: true

module Reservations
  # The service class for updating or inserting the reservation data
  class Upsert < ApplicationService
    include Reservations

    def call(payload:)
      klass_name = yield identify_payload(payload)
      new_payload = yield convert_payload(klass_name, payload)
      reservation = yield find_reservation(new_payload[:code])
      new_reservation = yield create_or_update(reservation, new_payload)

      Success(new_reservation)
    end

    private

    def identify_payload(payload)
      identifier_inst = Payload::Identifier.new
      identifier = identifier_inst.call(payload: payload)

      if identifier.success?
        Success(identifier.success)
      else
        Failure(identifier.failure)
      end
    end

    def convert_payload(klass_name, payload)
      # Factory Method (Design Pattern)
      namespace = "Reservations::Payload::Converter::"
      converter_klass = "#{namespace}#{klass_name}".constantize
      converter_inst = converter_klass.new
      converter = converter_inst.call(payload: payload)

      if converter.success?
        Success(converter.success)
      else
        Failure(converter.failure)
      end
    end

    def create_or_update(reservation, payload)
      if reservation.present?
        nested_update(reservation, payload)
      else
        create_reservation(payload)
      end
    end

    def nested_update(reservation, payload)
      update_inst = Update.new
      update = update_inst.call(
        reservation: reservation,
        payload:     payload
      )

      if update.success?
        Success(update.success)
      else
        Failure(update.failure)
      end
    end
  end
end
