class ConsultationRequestsController < ApplicationController
  before_action :authenticate_user!,
    only: [:user_index, :new, :create, :cancel]
  before_action :authenticate_lawyer!,
    only: [:lawyer_index, :show, :accept, :accepted, :decline, :declined]

  layout 'inbox', except: :new

  def user_index
    @consultation_requests = current_user.consultations.pending
      .order(created_at: :desc).includes(:lawyer)
  end

  def lawyer_index
    @consultation_requests = current_lawyer.consultations.pending
      .order(created_at: :desc).includes(:user)
  end

  def show
    load_consultation_request
  end

  def new
    @consultation_request = Lawyer.find(params[:lawyer_id]).consultations.new
    @service = params[:service]
  end

  def create
    lawyer = Lawyer.find(params[:lawyer_id])
    @consultation_request = lawyer.consultations.new(consultation_params)
    current_user.consultations << @consultation_request

    if @consultation_request.save
      Client.create!(user: current_user, lawyer: lawyer)
      LawyerMailer.consultation_request_email(lawyer, @consultation_request).deliver
      redirect_to user_consultation_requests_path,
        notice: "Consultation request sent. You will receive a notification when #{lawyer.public_name} responds."
    else
      render :new
    end
  end

  def cancel
    Consultation.find(params[:id]).cancelled!
    redirect_to action: :user_index
  end

  def accept
    load_consultation_request
    @consultation_request.build_proposed_times
  end

  def accepted
    load_consultation_request
    @consultation_request.update(consultation_params)
    @consultation_request.status = :proposed

    if @consultation_request.save
      UserMailer.consultation_request_accepted_email(@consultation_request).deliver
      redirect_to lawyer_consultation_requests_path,
        notice: "Times proposed. You will receive a notification when #{@consultation_request.client_name} confirms."
    else
      render :accept
    end
  end

  def decline
    load_consultation_request
  end

  def declined
    load_consultation_request
    UserMailer.consultation_request_declined_email(@consultation_request, params[:reason]).deliver
    @consultation_request.declined!
    redirect_to action: :lawyer_index
  end

  private

  def consultation_params
    params.require(:consultation).permit :description,
      proposed_times_attributes: [:id, :time]
  end

  def load_consultation_request
    @consultation_request = Consultation.find(params[:id])
  end
end
