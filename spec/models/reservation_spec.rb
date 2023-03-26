require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe "validations" do
    let(:guest) { Guest.create(email: "guest@example.com", first_name: "John", last_name: "Doe") }

    context "when all required fields are present" do
      let(:reservation) do
        Reservation.new(
          reservation_code: "ABC123",
          start_date: Date.today,
          end_date: Date.today + 1,
          nights: 1,
          guests: 1,
          adults: 1,
          children: 0,
          infants: 0,
          status: "pending",
          guest_id: guest.id,
          currency: "USD",
          payout_price: 100.0,
          security_price: 50.0,
          total_price: 150.0
        )
      end

      it "is valid" do
        expect(reservation).to be_valid
      end
    end

    context "when a required field is missing" do
      let(:reservation) do
        Reservation.new(
          reservation_code: "ABC123",
          start_date: Date.today,
          end_date: Date.today + 1,
          nights: 1,
          guests: 1,
          adults: 1,
          children: 0,
          infants: 0,
          status: "pending",
          guest_id: guest.id,
          currency: "USD",
          payout_price: 100.0,
          security_price: 50.0
        )
      end

      it "is not valid" do
        expect(reservation).not_to be_valid
      end
    end

    context "when reservation code is not unique" do
      before { Reservation.create(
        reservation_code: "ABC123",
        start_date: Date.today,
        end_date: Date.today + 1,
        nights: 1,
        guests: 1,
        adults: 1,
        children: 0,
        infants: 0,
        status: "pending",
        guest_id: guest.id,
        currency: "USD",
        payout_price: 100.0,
        security_price: 50.0,
        total_price: 150.0) }

      let(:reservation) do
        Reservation.new(
          reservation_code: "ABC123",
          start_date: Date.today,
          end_date: Date.today + 2,
          nights: 1,
          guests: 1,
          adults: 1,
          children: 0,
          infants: 0,
          status: "pending",
          guest_id: guest.id,
          currency: "USD",
          payout_price: 100.0,
          security_price: 50.0,
          total_price: 150.0
        )
      end

      it "is not valid" do
        expect(reservation).not_to be_valid
      end
    end
  end
end