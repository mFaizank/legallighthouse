class LawyerMailer < ApplicationMailer
  def application_email(application)
    @application = application
    mail(to: @application.email, from: notification_email, subject: t('.subject'))
  end

  def approval_email(application)
    @application = application
    @domain = domain
    mail(to: @application.email, from: notification_email, subject: t('.subject'))
  end

  def rejection_email(application)
    @application = application
    mail(to: @application.email, from: notification_email, subject: t('.subject'))
  end

  def consultation_request_email(lawyer, consultation_request)
    @lawyer, @consultation_request = lawyer, consultation_request
    mail(to: @lawyer.email, from: notification_email, subject: 'You have received an consultation request')
  end

  def consultation_confirmed_email(consultation)
    @consultation = consultation
    mail(to: @consultation.lawyer.email, from: notification_email, subject: 'A consultation was booked')
  end

  def consultation_undecided_email(consultation)
    @consultation = consultation
    mail(to: @consultation.lawyer.email, from: notification_email, subject: 'None of the proposed times for a consultation were chosen')
  end
end
