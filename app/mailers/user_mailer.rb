class UserMailer < ApplicationMailer
  def consultation_request_accepted_email(consultation_request)
    @consultation_request = consultation_request
    mail(to: @consultation_request.user.email, subject: 'Your consultation request was accepted')
  end

  def consultation_request_declined_email(consultation_request, reason)
    @consultation_request, @reason = consultation_request, reason
    mail(to: @consultation_request.user.email, subject: 'Your consultation request was declined')
  end

  def consultation_confirmed_email(consultation)
    @consultation = consultation
    mail(to: @consultation.user.email, subject: 'Your consultation is booked')
  end

  def quote_created_email(quote)
    @quote = quote
    mail(to: @quote.user.email, subject: 'You received a quote')
  end

  def quote_modified_email(quote)
    @quote = quote
    mail(to: @quote.user.email, subject: 'A quote was modified by the lawyer')
  end

  def quote_cancelled_email(quote)
    @quote = quote
    mail(to: @quote.user.email, subject: 'A quote was cancelled by the lawyer')
  end
end
