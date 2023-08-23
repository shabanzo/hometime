# frozen_string_literal: true

require 'rails_helper'

# Unit Test
RSpec.describe Reservations::Payload::Converter::Airbnb, type: :service do
  let(:service) { described_class.new }

  describe '#call' do
    context 'when converting AirBNB payload' do
      let(:guest) do
        {
          'first_name': 'Wayne',
          'last_name':  'Woodbridge',
          'phone':      '639123456789',
          'email':      'wayne_woodbridge@bnb.com'
        }
      end
      let(:payload) do
        {
          'reservation_code': 'XXX12345678',
          'start_date':       '2021-04-14',
          'end_date':         '2021-04-18',
          'nights':           '4',
          'guests':           '4',
          'adults':           '2',
          'children':         '2',
          'infants':          '0',
          'status':           'accepted',
          'guest':            guest,
          'currency':         'AUD',
          'payout_price':     '4200.00',
          'security_price':   '500',
          'total_price':      '4700.00'
        }
      end

      it 'converts reservation_code to code' do
        result = service.call(payload: payload)
        expect(result).to be_success
        converted_payload = result.value!
        expect(converted_payload[:code]).to eq('XXX12345678')
        expect(converted_payload).not_to be_key(:reservation_code)
      end

      it 'converts guest to guest_attributes' do
        result = service.call(payload: payload)
        expect(result).to be_success
        converted_payload = result.value!
        expect(converted_payload[:guest_attributes]).to eq(guest)
        expect(converted_payload).not_to be_key(:guest)
      end
    end
  end
end
