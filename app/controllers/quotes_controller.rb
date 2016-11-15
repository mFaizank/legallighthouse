class QuotesController < ApplicationController
  before_action :authenticate_user!

  layout 'inbox'

  def index
    @quotes = current_user.quotes
  end

  def show
    load_quote
  end

  def accept
    load_quote
    @quote.accepted!
    redirect_to quotes_path
  end

  def reject
    load_quote
    @quote.rejected!
    redirect_to quotes_path
  end

  def request_modification
    load_quote
    # do something else
    redirect_to quotes_path
  end

  private

  def load_quote
    @quote = current_user.quotes.find(params[:id])
  end
end
