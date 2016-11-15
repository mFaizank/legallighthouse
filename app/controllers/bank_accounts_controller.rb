class BankAccountsController < ApplicationController

  def index
    unless current_lawyer.stripe_account_id.blank?
      stripe_account = get_stripe_account
      @external_accounts = get_external_bank_accounts(stripe_account).all(object: "bank_account")
    end
  end

  def create
    begin
      if current_lawyer.stripe_account_id.blank?
        account_response =  create_stripe_account
        if account_response.blank?
          flash[:notice] = "Account was not created."
          redirect_to :back
        else
          account_id = account_response.to_hash[:id]
          current_lawyer.update_column("stripe_account_id", account_id)
        end
      end

      token = create_bank_account_token

      stripe_account = get_stripe_account
      get_external_bank_accounts(stripe_account).create({external_account: token})
      flash[:notice] = "Bank account has been added successfully!"
      redirect_to bank_accounts_path
    rescue => error
      flash[:notice] = error.message
      redirect_to bank_accounts_path
    end
  end

  def update_default_bank_account
    begin
      stripe_account = get_stripe_account
      external_account = get_external_bank_account(stripe_account, params[:id])
      external_account.default_for_currency = true
      external_account.save
    rescue => error
      flash[:notice] = error.message
      redirect_to bank_accounts_path
    end
    flash[:notice] = "Bank account marked default!"
    redirect_to bank_accounts_path
  end

  def destroy
    begin
      stripe_account = get_stripe_account
      get_external_bank_account(stripe_account, params[:id]).delete()
      flash[:notice] = "Bank account deleted successfully!"
      redirect_to bank_accounts_path
    rescue => error
      flash[:notice] = error.message
      redirect_to bank_accounts_path
    end
  end


  private

  def create_stripe_account
    Stripe::Account.create({
      country: "US",
      managed: true,
      email: current_lawyer.email
      })
  end

  def create_bank_account_token
    Stripe::Token.create(
          bank_account: {
              country:  "US",
              currency: "usd",
              account_holder_name: params[:account_holder_name],
              account_holder_type: params[:account_holder_type],
              routing_number: params[:routing_number],
              account_number: params[:account_number],
          })
  end

end
