class ConsultationsController < ApplicationController
  before_action :authenticate_user!, only: [:user_index, :confirm, :cancel]
  before_action :authenticate_lawyer!, only: [:lawyer_index, :show, :schedule, :decline]

  layout 'inbox'

  def user_index
    # In Rails 5, enums can be used directly in where clause
    @consultations = current_user.consultations
      .where(status: Consultation.statuses.slice(:proposed, :confirmed).values)
      .order(created_at: :desc).includes(:lawyer)
  end

  def lawyer_index
    @consultations = current_lawyer.consultations.confirmed
      .order(created_at: :desc)
    @undecided_consultations = current_lawyer.consultations.undecided
      .order(created_at: :desc)
  end

  def confirm
    @consultation = Consultation.find(params[:id])
    @consultation.set_default_time
  end

  def confirmed
    @consultation = Consultation.find(params[:id])

    unless consultation_params[:time] == 'none'
      @consultation.time = consultation_params[:time]
      @consultation.status = :confirmed

      if @consultation.save
        UserMailer.consultation_confirmed_email(@consultation).deliver
        LawyerMailer.consultation_confirmed_email(@consultation).deliver
        redirect_to user_consultations_path,
          notice: "Consultation confirmed for #{@consultation.human_time}."
      else
        render :confirm
      end
    else
      @consultation.undecided!
      LawyerMailer.consultation_undecided_email(@consultation).deliver
      redirect_to user_consultations_path,
        notice: "#{@consultation.lawyer_name} has been notified that none of the proposed times were convenient, and may contact you at #{@consultation.user.phone_number} to schedule a consultation."
    end
  end

  private

  def consultation_params
    params.require(:consultation).permit(:time)
  end
end
