class AdminMailer < ApplicationMailer
  # default to: 'info@droitphare.ca'
  layout 'admin_mailer'

  def application_email(application)
    @application = application
    mail(to: info_email, subject: 'An application has been submitted')
  end

  def contact_email(contact)
    @contact = contact
    mail(to: info_email, from: @contact.email, subject: @contact.subject)
  end

  private

  def info_email
    host_name = case I18n.locale
    when :en
      'legallighthouse'
    when :fr
      'droitphare'
    end

    "info@#{host_name}.ca"
  end
end
