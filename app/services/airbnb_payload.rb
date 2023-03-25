class AirbnbPayload < PayloadParser

  def reservation_params
    {
      reservation_code: @params[:reservation_code],
      start_date:       @params[:start_date],
      end_date:         @params[:end_date],
      nights:           @params[:nights],
      guests:           @params[:guests],
      adults:           @params[:adults],
      children:         @params[:children],
      infants:          @params[:infants],
      status:           @params[:status],
      currency:         @params[:currency],
      payout_price:     @params[:payout_price],
      security_price:   @params[:security_price],
      total_price:      @params[:total_price]
    }
  end

  def guest_params
    {
      first_name: @params[:guest][:first_name] ,
      last_name:  @params[:guest][:last_name],
      phone:      @params[:guest][:phone],
      email:      @params[:guest][:email]
    }
  end

  def guest_email
    @params[:guest][:email]
  end

end