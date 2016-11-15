class LawyerLeadsController < ApplicationController
  def create
    lead = LawyerLead.new
    lead.first_name = params[:first_name] if params[:first_name]
    lead.last_name = params[:last_name] if params[:last_name]
    lead.bars = params[:bars]
    lead.email = params[:email]
    lead.practices = params[:practices].values.delete_if &:empty?


    notice = if lead.save
      { notice: t('.success') }
    else
      { alert: t('.failure') }
    end

    redirect_to(page_path('lawyers'), notice)
  end
end
