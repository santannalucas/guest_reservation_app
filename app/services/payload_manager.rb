class PayloadManager

  def self.build(payload)
    payload_type = determine_payload_type(payload)
    payload_select(payload_type).new(payload)
  end

  private

  def self.determine_payload_type(payload)
    if payload.key?(:reservation_code)
      :payload_airbnb
    elsif payload.dig(:reservation, :code)
      :payload_booking_com
    else
      raise 'Unsupported payload type'
    end
  end

  def self.payload_select(payload_type)
    case payload_type
    when :payload_airbnb
      AirbnbPayload
    when :payload_booking_com
      BookingcomPayload
    end
  end
end