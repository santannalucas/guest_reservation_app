class PayloadParser
  def initialize(params)
    @params = params
  end

  def reservation_params
    raise NotImplementedError, "Subclasses must implement this method"
  end

  def guest_email
    raise NotImplementedError, "Subclasses must implement this method"
  end
end