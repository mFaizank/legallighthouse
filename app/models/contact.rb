class Contact < ActiveRecord::Base
  validates :name, :email, :message, presence: true
  validates :email, format: { with: Devise.email_regexp }
end
