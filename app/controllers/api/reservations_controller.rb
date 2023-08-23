# frozen_string_literal: true

module Api
  # API Controller for Reservation
  class ReservationsController < ApplicationController
    # POST @api/reservations/upsert
    def upsert
      upsert = upsert_inst.call(payload: open_params)

      if upsert.success?
        serialized_reservation = ReservationSerializer.serialize(upsert.success)

        render json:   serialized_reservation,
               status: :ok
      else
        render status: upsert.failure
      end
    end

    private

    def upsert_inst
      ::Reservations::Upsert.new
    end

    # Disable strong parameters because
    # 1. The parameters are dynamic
    # 2. ::Reservations::Payload::Identifier and ::Reservations::Payload::Converter will handle it
    def open_params
      @open_params ||= request.parameters.except(:controller, :action).
                       deep_transform_keys(&:to_sym)
    end
  end
end
