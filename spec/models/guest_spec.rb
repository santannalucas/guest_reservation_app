require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe "validations" do
    it "is invalid without an email" do
      guest = Guest.new(email: nil)
      expect(guest).not_to be_valid
      expect(guest.errors[:email]).to include("can't be blank")
    end

    it "is invalid without a first name" do
      guest = Guest.new(first_name: nil)
      expect(guest).not_to be_valid
      expect(guest.errors[:first_name]).to include("can't be blank")
    end

    it "is invalid without a last name" do
      guest = Guest.new(last_name: nil)
      expect(guest).not_to be_valid
      expect(guest.errors[:last_name]).to include("can't be blank")
    end

    it "is invalid with a duplicate email" do
      Guest.create!(
        email: "test@example.com",
        first_name: "John",
        last_name: "Doe"
      )

      guest = Guest.new(
        email: "test@example.com",
        first_name: "Jane",
        last_name: "Doe"
      )

      expect(guest).not_to be_valid
      expect(guest.errors[:email]).to include("has already been taken")
    end
  end

  describe "associations" do
    it "has many reservations" do
      guest = Guest.new
      expect(guest.reservations).to eq([])
    end

    it "destroys associated reservations on deletion" do
      guest = Guest.create!(
        email: "test@example.com",
        first_name: "John",
        last_name: "Doe"
      )

      reservation = guest.reservations.create!(
        reservation_code: "ABC123",
        start_date: Date.today,
        end_date: Date.tomorrow,
        nights: 1,
        guests: 1,
        adults: 1,
        children: 0,
        infants: 0,
        status: "confirmed",
        currency: "USD",
        payout_price: 100.0,
        security_price: 0.0,
        total_price: 100.0
      )

      expect { guest.destroy }.to change { Reservation.count }.by(-1)
    end
  end
end