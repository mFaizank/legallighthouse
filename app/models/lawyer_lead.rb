class LawyerLead < ActiveRecord::Base
  validates :email, presence: true
  validates :email, format: { with: Devise.email_regexp }
end
