class PaymentRequest < ActiveRecord::Base
  belongs_to :quote
end
