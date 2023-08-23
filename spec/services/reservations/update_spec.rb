# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reservations::Update, type: :service do
  subject(:service) { described_class.new }

  let(:reservation) { create(:reservation) }
  let(:guest) { create(:guest) }

  context 'when updating a reservation and guest' do
    let(:payload) do
      {
        guests:           5,
        guest_attributes: {
          first_name: 'Updated',
          last_name:  'Guest'
        }
      }
    end

    it 'updates the reservation and guest' do
      result = service.call(reservation: reservation, payload: payload)

      expect(result).to be_success
      expect(result.success).to eq(reservation.reload)
      expect(reservation.reload.guest.first_name).to eq('Updated')
    end
  end

  context 'when updating guest fails' do
    let(:payload) do
      {
        guests:           5,
        guest_attributes: {
          first_name: 'Updated',
          last_name:  'Guest',
          email:      guest.email
        }
      }
    end

    it 'returns a failure result' do
      result = service.call(reservation: reservation, payload: payload)

      expect(result).to be_failure
      expect(result.failure[:status]).to eq(:unprocessable_entity)
    end

    it 'rollbacks the reservation' do
      expect { service.call(reservation: reservation, payload: payload) }.not_to(
        change do
          reservation.reload
          reservation.status
        end
      )
    end
  end
end
