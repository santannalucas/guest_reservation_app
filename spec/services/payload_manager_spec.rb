require 'rails_helper'

RSpec.describe PayloadManager do
  describe '.build' do
    let(:airbnb_payload) { { reservation_code: 'ABCD1234' } }
    let(:bookingcom_payload) { { reservation: { code: '1234ABCD' } } }

    context 'when given an Airbnb payload' do
      it 'returns an AirbnbPayload instance' do
        payload = described_class.build(airbnb_payload)
        expect(payload).to be_an_instance_of(AirbnbPayload)
      end
    end

    context 'when given a Booking.com payload' do
      it 'returns a BookingcomPayload instance' do
        payload = described_class.build(bookingcom_payload)
        expect(payload).to be_an_instance_of(BookingcomPayload)
      end
    end

    context 'when given an unsupported payload type' do
      it 'raises an error' do
        expect {
          described_class.build({ unsupported: true })
        }.to raise_error('Unsupported payload type')
      end
    end
  end
end