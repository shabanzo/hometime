# frozen_string_literal: true

require 'rails_helper'

# Integration Test
RSpec.describe Api::V1::ReservationsController, type: :controller do
  describe 'POST #upsert' do
    before do
      post :upsert, params: payload
    end

    context 'when the payload is valid' do
      let(:payload) do
        {
          'reservation_code' => 'YYY12345678',
          'start_date'       => '2021-04-14',
          'end_date'         => '2021-04-18',
          'nights'           => '4',
          'guests'           => '4',
          'adults'           => '2',
          'children'         => '2',
          'infants'          => '0',
          'status'           => 'accepted',
          'guest'            => {
            'first_name' => 'Wayne',
            'last_name'  => 'Woodbridge',
            'phone'      => '639123456789',
            'email'      => 'wayne_woodbridge@bnb.com'
          },
          'currency'         => 'AUD',
          'payout_price'     => '4200.00',
          'security_price'   => '500',
          'total_price'      => '4700.00'
        }
      end

      let(:expected_response) do
        {
          'adults'         => 2,
          'children'       => 2,
          'code'           => 'YYY12345678',
          'currency'       => 'AUD',
          'end_date'       => '2021-04-18',
          'guest'          => {
            'email'      => 'wayne_woodbridge@bnb.com',
            'first_name' => 'Wayne',
            'last_name'  => 'Woodbridge',
            'phone'      => '639123456789'
          },
          'guests'         => 4,
          'infants'        => 0,
          'nights'         => 4,
          'payout_price'   => '4200.0',
          'security_price' => '500.0',
          'start_date'     => '2021-04-14',
          'status'         => 'accepted',
          'total_price'    => '4700.0'
        }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the created/updated reservation' do
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end

    context 'when the payload is invalid' do
      let(:payload) { {} }

      it 'returns an error response' do
        expect(response).to have_http_status(:not_implemented)
      end

      it 'returns the errors message' do
        expect(JSON.parse(response.body)).to eq({ 'message'=>'The payload can not be identified!' })
      end
    end
  end
end
