class CreditCardsController < ApplicationController

  def new
  end

  def index
    unless current_lawyer.nil? || current_lawyer.stripe_token.blank?
      @customer = get_stripe_customer(current_lawyer.stripe_token)
      @credit_cards = get_all_credit_cards(@customer)
    end
    unless current_user.nil? || current_user.stripe_token.blank?
      @client_customer = get_stripe_customer(current_user.stripe_token)
      @client_credit_cards = get_all_credit_cards(@client_customer)
    end
  end

  def create
    token = create_credit_card_token

    if params[:lawyer_id].blank?
      if current_user.stripe_token.blank?
      customer = stripe_create_customer_object(token, current_user)
       current_user.update_column(:stripe_token, customer.id)
      else
       customer = get_stripe_customer(current_user.stripe_token)
       customer.sources.create({source: token.id})
      end

    else
      if current_lawyer.stripe_token.blank?
      customer = stripe_create_customer_object(token, current_lawyer)
       current_lawyer.update_column(stripe_token: customer.id)
      else
        customer = get_stripe_customer(current_lawyer.stripe_token)
        customer.sources.create({source: token.id})
      end
    end

    flash[:notice] = "Credit Card has been added successfully"
    redirect_to credit_cards_path

    rescue Stripe::CardError => e
      flash[:error] = e.message
      if params[:lawyer_id].blank?
        redirect_to new_credit_card_path(client_id: current_user.id)
      else
        redirect_to new_credit_card_path
      end
  end

  def destroy
    customer = get_stripe_customer(params[:customer_id])
    get_credit_card(customer, params[:id]).delete()
    flash[:notice] = "Credit Card has been deleted successfully"
    redirect_to credit_cards_path
  end

  def update_default_card
    customer = get_stripe_customer(params[:customer_id])
    customer.default_card = params[:id]
    customer.save
    redirect_to credit_cards_path
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating card info: #{e.message}"
    errors.add :base, "#{e.message}"
    false
  end

  private

  def create_credit_card_token
    Stripe::Token.create(
      card: {
        number: params[:credit_card],
        exp_month: params[:month_num],
        exp_year: params[:year_num],
        cvc:  params[:secret_code]
      }
    )
  end

  def stripe_create_customer_object(token, user)
    Stripe::Customer.create(
        card: token.id,
        email: user.email,
        description: user.email
      )
  end

end
