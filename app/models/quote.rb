class Quote < ActiveRecord::Base
  mount_uploader :agreement, AgreementUploader

  enum status: %i(pending accepted rejected)

  belongs_to :lawyer
  belongs_to :user
  has_many :payments
  has_many :payment_requests

  validates :agreement, :fee, presence: true
  validates :fee, :advance,
    numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
