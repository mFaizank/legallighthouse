class LeadsController < ApplicationController
  def create
    lead = Lead.new
    lead.email = params[:email]
    lead.business = params[:seeking] == 'business' ? true : false

    notice = if lead.save
      { notice: t('.success') }
    else
      { alert: t('.failure') }
    end

    redirect_to(page_path('home'), notice)
  end
end
