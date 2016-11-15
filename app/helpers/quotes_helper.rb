module QuotesHelper
  def calculate_payment_done(quote_id)
    payment_requests = PaymentRequest.where(quote_id: quote_id, disbursement: false, status: "paid")
    total = 0.0
    unless payment_requests.blank?
      payment_requests.each do |payment_request|
        total = total + payment_request.amount
      end
    end
    return total
  end
end
