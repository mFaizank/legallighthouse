class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def set_locale
    I18n.locale = params[:locale] || case request.host
    when 'www.legallighthouse.ca'
      :en
    when 'www.droitphare.ca'
      :fr
    else
      I18n.default_locale
    end
  end

  def get_stripe_account
    Stripe::Account.retrieve(current_lawyer.stripe_account_id)
  end

  def get_external_bank_account(stripe_account, stripe_bank_account_id)
    stripe_account.external_accounts.retrieve(stripe_bank_account_id)
  end

  def get_external_bank_accounts(stripe_account)
    stripe_account.external_accounts
  end

  def get_stripe_customer(stripe_token)
    Stripe::Customer.retrieve(stripe_token)
  end

  def get_all_credit_cards(customer)
    customer.sources.all(object: "card")
  end

  def get_credit_card(customer, id)
    customer.sources.retrieve(id)
  end

  def get_default_credit_card(customer)
    customer.sources.retrieve(customer['default_source'])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [
      :first_name, :last_name, :bar, :bar_number, :year_of_call, :phone_number,
      :cv, :cv_cache, :business, :name, :title, :postal_code, :token,
      :occupation
    ]
  end

  def after_sign_in_path_for(resource)
    case resource
    when Lawyer
      edit_profile_path
    when Admin
      '/admin/applications'
    else
      root_path
    end
  end
end
