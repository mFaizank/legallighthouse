class PaymentRequestsController < ApplicationController

  def index
    @quote   = Quote.find(params[:quote_id])
    @payment_requests = @quote.payment_requests
     unless current_client.stripe_token.blank?
      @client_customer = get_stripe_customer(current_client.stripe_token)
      @card = get_default_credit_card(@client_customer) unless @client_customer['default_source'].blank?
    end
  end


  def new
    if current_lawyer.stripe_account_id.blank?
      flash[:notice] = "Please create a bank account first"
      redirect_to root_path and return
    else
      stripe_account = get_stripe_account
      @external_accounts = get_external_bank_accounts(stripe_account).all(object: "bank_account")
      if @external_accounts.count == 0
        flash[:notice] = "Please create a bank account first"
        redirect_to root_path and return
      end
    end
    @quote   = Quote.find(params[:quote_id])
    @payment_request = PaymentRequest.new
  end

  def create
    @quote   = Quote.find(params[:quote_id])
    amount_requested = params[:payment_request][:amount].to_f
    if amount_requested == 0
      flash[:notice] = "Please enter a valid amount"
    elsif total_amount_requested(amount_requested, @quote) > @quote.fee
      flash[:error] = "Total of amount requested exceed the quotation fee"
    else
      payment_request = PaymentRequest.new(payment_request_params)
      payment_request.save
      ContactMailer.send_payment_request_email(@quote, payment_request)
      flash[:notice] = "Payment request made successfully"
    end
    redirect_to root_path
  end

  def disbursement
    @quote = Quote.find(params[:quote_id])
    unless @quote.disbursement > 0
      flash[:error] = "No disbursement amount decided"
      redirect_to root_path
    end
  end

  def request_disbursement
    quote   = Quote.find(params[:quote_id])
    payment_request = PaymentRequest.new(payment_request_params)
    payment_request.disbursement = true
    payment_request.save
    flash[:notice] = "Disbursement Request made successfully"
    ContactMailer.send_payment_request_email(quote, payment_request)
    redirect_to root_path
  end

  private

  def sum_of_payments_and_requests(quote_id)
    payment_requests = PaymentRequest.where(quote_id: quote_id, disbursement: false)
    total = 0.0
    unless payment_requests.blank?
      payment_requests.each do |payment_request|
        total = total + payment_request.amount
      end
    end
    return total
  end

  def total_amount_requested(amount_requested, quote)
    amount_requested + sum_of_payments_and_requests(quote.id)
  end

  def payment_request_params
    params.require(:payment_request).permit(:quote_id, :amount, :status, :description)
  end

end
