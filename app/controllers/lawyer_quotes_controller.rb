class LawyerQuotesController < ApplicationController
  before_action :authenticate_lawyer!

  layout 'inbox'

  def index
    @quotes = current_lawyer.quotes
  end

  def show
    @quote = current_lawyer.quotes.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @quote = current_lawyer.quotes.new
  end

  def create
    @user = User.find(params[:user_id])
    @quote = current_lawyer.quotes.new(quote_params)
    @quote.user = @user

    if @quote.save
      UserMailer.quote_created_email(@quote).deliver
      redirect_to lawyer_quotes_path, notice: 'Quote sent.'
    else
      render :new
    end
  end

  def edit
    @quote = current_lawyer.quotes.find(params[:id])
  end

  def update
    @quote = current_lawyer.quotes.find(params[:id])

    if @quote.update(quote_params)
      UserMailer.quote_modified_email(@quote).deliver
      redirect_to lawyer_quotes_path, notice: 'Quote saved.'
    else
      render :edit
    end
  end

  def cancel
    quote = current_lawyer.quotes.find(params[:id])
    quote.destroy
    UserMailer.quote_cancelled_email(quote).deliver
    redirect_to lawyer_quotes_path, notice: 'Quote cancelled.'
  end

  private

  def quote_params
    params.require(:quote).permit(:agreement, :fee, :advance, :completion_date)
  end
end
