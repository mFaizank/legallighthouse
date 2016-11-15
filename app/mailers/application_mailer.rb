class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@droitphare.ca'
  layout 'mailer'

  protected

  def notification_email
    host_name = case I18n.locale
    when :en
      'legallighthouse'
    when :fr
      'droitphare'
    end

    "notifications@#{host_name}.ca"
  end

  def domain
    case I18n.locale
    when :en
      'http://www.legallighthouse.ca'
    when :fr
      'http://www.droitphare.ca'
    end
  end
end
