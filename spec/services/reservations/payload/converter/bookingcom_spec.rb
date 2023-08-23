# frozen_string_literal: true

require 'rails_helper'

# Unit Test
RSpec.describe Reservations::Payload::Converter::Bookingcom, type: :service do
  let(:service) { described_class.new }

  describe '#call' do
    context 'when converting Bookingcom payload' do
      let(:input_payload) do
        {
          'reservation': {
            'code':                            'YYY12345678',
            'start_date':                      '2021-04-14',
            'end_date':                        '2021-04-18',
            'nights':                          4,
            'number_of_guests':                4,
            'guest_details':                   {
              'number_of_adults':   2,
              'number_of_children': 2,
              'number_of_infants':  0
            },
            'status_type':                     'accepted',
            'guest_first_name':                'Wayne',
            'guest_last_name':                 'Woodbridge',
            'guest_phone_numbers':             %w[639123456789 639123456789],
            'guest_email':                     'wayne_woodbridge@bnb.com',
            'host_currency':                   'AUD',
            'expected_payout_amount':          '4200.00',
            'listing_security_price_accurate': '500.00',
            'total_paid_amount_accurate':      '4700.00'
          }
        }
      end

      let(:expected_payload) do
        {
          code:             'YYY12345678',
          start_date:       '2021-04-14',
          end_date:         '2021-04-18',
          nights:           4,
          guests:           4,
          adults:           2,
          children:         2,
          infants:          0,
          status:           'accepted',
          guest_attributes: {
            first_name: 'Wayne',
            last_name:  'Woodbridge',
            phone:      '639123456789',
            email:      'wayne_woodbridge@bnb.com'
          },
          currency:         'AUD',
          payout_price:     '4200.00',
          security_price:   '500.00',
          total_price:      '4700.00'
        }
      end

      it 'converts Bookingcom payload' do
        result = service.call(payload: input_payload)
        expect(result).to be_success
        converted_payload = result.value!

        expect(converted_payload).to eq(expected_payload)
      end
    end
  end
end
