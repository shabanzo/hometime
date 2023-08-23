# frozen_string_literal: true

require 'rails_helper'

# Unit Test
RSpec.describe Reservations::Payload::Identifier, type: :service do
  let(:service) { described_class.new }

  context 'when payload is for Bookingcom' do
    let(:payload) { { 'reservation' => {} } }

    it 'identifies the payload as Bookingcom' do
      result = service.call(payload: payload)
      expect(result).to be_success
      expect(result.value!).to eq('Bookingcom')
    end
  end

  context 'when payload is for Airbnb' do
    let(:payload) { { 'reservation_code' => 'XXX123' } }

    it 'identifies the payload as Airbnb' do
      result = service.call(payload: payload)
      expect(result).to be_success
      expect(result.value!).to eq('Airbnb')
    end
  end

  context 'when payload is not identified' do
    let(:payload) { { 'unknown_key' => 'value' } }

    it 'returns a failure result' do
      result = service.call(payload: payload)
      expect(result).to be_failure
      expect(result.failure[:status]).to eq(:not_implemented)
      expect(result.failure[:errors]).to eq('The payload can not be identified!')
    end
  end
end
