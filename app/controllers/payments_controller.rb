class PaymentsController < ApplicationController

  def new
    @quote   = Quote.find(params[:quote_id])
    @payment = Payment.new
    unless current_user.stripe_token.blank?
      @client_customer = get_stripe_customer(current_user.stripe_token)
      @card = get_default_credit_card(@client_customer) unless @client_customer['default_source'].blank?
    end
  end

  def pay_fee_to_lawyer
    payment_request = PaymentRequest.find(params[:id])
    quote = payment_request.quote
    lawyer = quote.lawyer
    if lawyer.stripe_account_id.blank?
      flash[:notice] = "Lawyer has no default bank account added. Please contact the lawyer"
      redirect_to root_path and return
    else
      stripe_account = get_stripe_account
      @external_accounts = get_external_bank_accounts(stripe_account).all(object: "bank_account")
      if @external_accounts.count == 0
        flash[:notice] = "Lawyer has no default bank account added. Please contact the lawyer"
        redirect_to root_path and return
      end
    end

    customer = get_stripe_customer(current_user.stripe_token)
    payment = create_charge(customer, payment_request.amount.to_f, "Fee paid from #{current_user.email} to #{lawyer.email}", 'usd')

     if payment.status == "succeeded"
      transfer = create_transfer(payment_request.amount.to_f,'usd', lawyer.stripe_account_id, "Quote fee of #{payment_request.amount} paid to #{lawyer.email} by #{current_user.email}")
      if transfer.status == "paid"
        Payment.create(amount: payment_request.amount, quote_id: quote.id, user_id: current_user.id, lawyer_id: lawyer.id , payment_type: "quote_fee")
        payment_request.update_column(:status, "paid")
        flash[:notice] = "Quote fee of #{payment_request.amount} paid to #{lawyer.email} sucessfully"
      else
        flash[:error] = "transfer error"
      end
    else
      flash[:error] = "payment error"
    end
    redirect_to root_path
  end

  def charge_flat_fee_lawyer
    unless current_user.stripe_token.blank?
    customer = get_stripe_customer(current_user.stripe_token)
    payment = create_charge(customer, "19.99".to_f, "Technology Fee from Lawyer  #{current_user.email}", 'usd')
      if payment.status == "succeeded"
         Payment.create(amount: 19.99, quote_id: params[:quote_id], lawyer_id: current_user.id, payment_type: "technology_fee")
        flash[:notice] = "Technology fee of $19.99 charged successfully from laywer"
      end
    else
      flash[:error] = "Please add a credit card first"
    end
    redirect_to "/"
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to "/"
  end


  def create
    customer = get_stripe_customer(current_user.stripe_token)
    payment = create_charge(customer, "49.99".to_f, "Technology Fee from Client  #{current_user.email}", 'usd')

     if payment.status == "succeeded"
      Payment.create(amount: 49.99, quote_id: params[:quote_id], user_id: current_user.id, payment_type: "technology_fee")
      flash[:notice] = "Technology fee of $49.99 charged successfully from client"
      redirect_to root_path
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_quote_payment_path(params[:quote_id])
  end


  def show
    @quote = Quote.find(params[:quote_id])
    @payment = Payment.find(params[:id])
    @paid_by = (@payment.payment_type == "technology_fee" and !@payment.lawyer_id.blank?) ?  @payment.lawyer.email : ( @payment.payment_type == "technology_fee" and !@payment.user_id.blank?) ? @payment.user.email : ( @payment.payment_type == "quote_fee") ? @payment.user.email : "none"
    @paid_to = @payment.payment_type == "technology_fee" ? "Legal Lighthouse Inc." : @payment.lawyer.email
  end

  def lawyer_history
    @technology_fees = Payment.where("lawyer_id = #{current_user.id} and payment_type = 'technology_fee'").order("created_at desc")
    @quote_fees = Payment.where("lawyer_id = #{current_user.id} and payment_type = 'quote_fee'").order("created_at desc")
  end

  def client_history
    @technology_fees = Payment.where("user_id = #{current_user.id} and payment_type = 'technology_fee'").order("created_at desc")
    @quote_fees = Payment.where("user_id = #{current_user.id} and payment_type = 'quote_fee'").order("created_at desc")
  end


  private

  def create_charge(customer, amount, description, currency)
     Stripe::Charge.create(
        customer: customer.id,
        amount: (amount * 100).to_i,
        description: description,
        currency: currency
      )
  end

  def create_transfer(amount, currency, destination, description)
    Stripe::Transfer.create(
         amount: (amount * 100).to_i,
         currency: currency,
         destination: destination,
         description: description
        )
  end
end
