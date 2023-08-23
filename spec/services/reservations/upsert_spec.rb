require 'rails_helper'

# Unit Test
RSpec.describe ::Reservations::Upsert, type: :service do
  let(:service) { described_class.new }

  describe '#call' do
    context 'when the payload is valid' do
      let(:payload) do
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

      let(:converted_payload) do
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

      let(:identifier_result) do
        instance_double(
          ::Dry::Monads::Result::Success,
          success?: true, success: 'Bookingcom'
        )
      end

      let(:identifier_inst) do
        instance_double(
          ::Reservations::Payload::Identifier,
          call: identifier_result
        )
      end

      let(:converter_result) do
        instance_double(
          ::Dry::Monads::Result::Success,
          success?: true, success: converted_payload
        )
      end

      let(:converter_inst) do
        instance_double(
          ::Reservations::Payload::Converter::Airbnb,
          call: converter_result
        )
      end

      before do
        allow(::Reservations::Payload::Identifier).to receive(:new).and_return(identifier_inst)
        allow(::Reservations::Payload::Converter::Airbnb).to receive(:new).and_return(converter_inst)
      end

      context 'when a new reservation is coming' do
        it 'creates a new reservation' do
          expect { service.call(payload: payload) }.to change(Reservation, :count).by(1)
        end
      end

      context 'when an existing reservation is coming' do
        let!(:guest) { create(:guest, email: 'wayne_woodbridge@bnb.com') }
        let!(:reservation) { create(:reservation, code: 'YYY12345678', status: 'pending', guest: guest) }

        it 'does not create a new reservation' do
          expect { service.call(payload: payload) }.not_to change(Reservation, :count)
        end

        it 'updates the existing reservation' do
          expect { service.call(payload: payload) }.to(change do
            reservation.reload
            reservation.status
          end)
        end

        it 'updates the existing guest that reserved the unit' do
          expect { service.call(payload: payload) }.to(change do
            guest.reload
            guest.first_name
          end)
        end
      end
    end

    context 'when payload identification fails' do
      let(:invalid_payload) { {} }

      let(:identifier_result) do
        instance_double(
          ::Dry::Monads::Result::Failure,
          success?: false, failure: :not_implemented
        )
      end

      let(:identifier_inst) do
        instance_double(
          ::Reservations::Payload::Identifier,
          call: identifier_result
        )
      end

      before do
        allow(::Reservations::Payload::Identifier).to receive(:new).and_return(identifier_inst)
      end

      it 'returns a failure result' do
        result = service.call(payload: invalid_payload)
        expect(result).to be_failure
        expect(result.failure).to eq(:not_implemented)
      end
    end
  end
end
