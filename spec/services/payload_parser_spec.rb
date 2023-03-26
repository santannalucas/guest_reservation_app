require 'rails_helper'

RSpec.describe PayloadParser do

  describe '#reservation_params' do
    it 'should raise NotImplementedError' do
      payload_parser = PayloadParser.new({})
      expect{ payload_parser.reservation_params }.to raise_error(NotImplementedError)
    end
  end

  describe '#guest_email' do
    it 'should raise NotImplementedError' do
      payload_parser = PayloadParser.new({})
      expect{ payload_parser.guest_email }.to raise_error(NotImplementedError)
    end
  end

  describe AirbnbPayload do
    let(:params) do
      {
        "reservation_code": "YYY12345678",
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

    describe "#reservation_params" do
      it "returns the correct reservation params" do
        parser = AirbnbPayload.new(params)
        expect(parser.reservation_params).to eq(
                                               {
                                                 reservation_code: "YYY12345678",
                                                 start_date: "2021-04-14",
                                                 end_date: "2021-04-18",
                                                 nights: 4,
                                                 guests: 4,
                                                 adults: 2,
                                                 children: 2,
                                                 infants: 0,
                                                 status: "accepted",
                                                 currency: "AUD",
                                                 payout_price: "4200.00",
                                                 security_price: "500",
                                                 total_price: "4700.00"
                                               }
                                             )
      end
    end

    describe "#guest_params" do
      it "returns the correct guest params" do
        parser = AirbnbPayload.new(params)
        expect(parser.guest_params).to eq(
                                         {
                                           first_name: "Wayne",
                                           last_name: "Woodbridge",
                                           phone: "639123456789",
                                           email: "wayne_woodbridge@bnb.com"
                                         }
                                       )
      end
    end

    describe "#guest_email" do
      it "returns the correct guest email" do
        parser = AirbnbPayload.new(params)
        expect(parser.guest_email).to eq("wayne_woodbridge@bnb.com")
      end
    end
  end

  describe BookingcomPayload do
    let(:params) do
      {
        "reservation": {
          "code": "XXX12345678",
          "start_date": "2021-03-12",
          "end_date": "2021-03-16",
          "expected_payout_amount": "3800.00",
          "guest_details": {
            "localized_description": "4 guests",
            "number_of_adults": 2,
            "number_of_children": 2,
            "number_of_infants": 0
          },
          "guest_email": "wayne_woodbridge@bnb.com",
          "guest_first_name": "Wayne",
          "guest_last_name": "Woodbridge",
          "guest_phone_numbers": ["639123456789","639123456789"],
          "listing_security_price_accurate": "500.00",
          "host_currency": "AUD",
          "nights": 4,
          "number_of_guests": 4,
          "status_type": "accepted",
          "total_paid_amount_accurate": "4300.00"
        }
      }
    end

    describe "#reservation_params" do
      it "returns the correct reservation params" do
        parser = BookingcomPayload.new(params)
        expect(parser.reservation_params).to eq(
                                               {
                                                 reservation_code: "XXX12345678",
                                                 start_date: "2021-03-12",
                                                 end_date: "2021-03-16",
                                                 nights: 4,
                                                 guests: 4,
                                                 adults: 2,
                                                 children: 2,
                                                 infants: 0,
                                                 status: "accepted",
                                                 currency: "AUD",
                                                 payout_price: "3800.00",
                                                 security_price: "500.00",
                                                 total_price: "4300.00"
                                               }
                                             )
      end
    end

    describe "#guest_params" do
      it "returns the correct guest params" do
        parser = BookingcomPayload.new(params)
        expect(parser.guest_params).to eq(
                                         {
                                           first_name: "Wayne",
                                           last_name: "Woodbridge",
                                           phone: ["639123456789","639123456789"],
                                           email: "wayne_woodbridge@bnb.com"
                                         }
                                       )
      end
    end

    describe "#guest_email" do
      it "returns the correct guest email" do
        parser = BookingcomPayload.new(params)
        expect(parser.guest_email).to eq("wayne_woodbridge@bnb.com")
      end
    end
  end

end
