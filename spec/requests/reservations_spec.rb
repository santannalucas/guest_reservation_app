require 'rails_helper'

RSpec.describe "Reservations", type: :request do

  let(:valid_reservation_params) do
    {
      "reservation_code": "LSY12345678",
      "start_date": "2021-04-14",
      "end_date": "2021-04-18",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "639123456789",
        "email": "wayne_woodbridge@bnb.com"
      },
      "currency": "AUD",
      "payout_price": "4200.00",
      "security_price": "500",
      "total_price": "4700.00"
    }
  end

  let(:updated_reservation_params) do
    {
      "reservation_code": "LSY12345678",
      "start_date": "2021-04-14",
      "end_date": "2021-04-18",
      "nights": 3,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "631239456789",
        "email": "wayne_woodbridge@bnb.com"
      },
      "currency": "AUD",
      "payout_price": "4200.00",
      "security_price": "500",
      "total_price": "4700.00"
    }
  end

  let(:invalid_user_params) do
    {
      "reservation_code": "XSY12345678",
      "start_date": "2021-04-14",
      "end_date": "2021-04-18",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "first_name": "",
        "last_name": "",
        "phone": "639123456789",
        "email": ""
      },
      "currency": "AUD",
      "payout_price": "4200.00",
      "security_price": "500",
      "total_price": "4700.00"
    }
  end

  let(:invalid_reservation_params) do
    {
      "reservation_code": "",
    }
  end

  context 'when reservation and guest are created successfully' do
    it 'creates a new reservation' do
      post '/reservations', params: valid_reservation_params
      expect(response).to have_http_status(:created)
      expect(Reservation.count).to eq(1)
      expect(Guest.count).to eq(1)
    end
  end

  context 'when guest fails to save' do
    it 'does not create reservation and returns unprocessable_entity status code' do
      post '/reservations', params: invalid_user_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Reservation.count).to eq(0)
      expect(Guest.count).to eq(0)
    end
  end

  context 'when reservation fails to save' do
    it 'does not create reservation and returns unprocessable_entity status code' do
      post '/reservations', params: invalid_reservation_params
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Reservation.count).to eq(0)
      expect(Guest.count).to eq(0)
    end
  end

  context 'when reservation is updated occurs' do
    it 'does update reservation and returns changes' do
      post '/reservations', params: updated_reservation_params
      expect(response).to have_http_status(:created)
      expected_json = {
          "id"=> Reservation.last.id,
          "reservation_code"=> "LSY12345678",
          "start_date"=> "2021-04-14",
          "end_date"=> "2021-04-18",
          "nights"=> 3,
          "guests"=> 4,
          "adults"=> 2,
          "children"=> 2,
          "infants"=> 0,
          "status"=> "accepted",
          "guest_id"=> Guest.last.id,
          "currency"=> "AUD",
          "payout_price"=> "4200.0",
          "security_price"=> "500.0",
          "total_price"=> "4700.0",
          "created_at" => Reservation.last.created_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ'),
          "updated_at" => Reservation.last.updated_at.strftime('%Y-%m-%dT%H:%M:%S.%3NZ')
        }
      expect(JSON.parse(response.body)).to eq(expected_json)
    end
  end

  context 'when an exception occurs' do
    it 'does not create reservation and returns unprocessable_entity status code' do
      post '/reservations', params: {}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Reservation.count).to eq(0)
      expect(Guest.count).to eq(0)
    end
  end

end
