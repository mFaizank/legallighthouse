class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      AdminMailer.contact_email(@contact).deliver
      redirect_to root_path, notice: I18n.t('alerts.contact_form')
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
