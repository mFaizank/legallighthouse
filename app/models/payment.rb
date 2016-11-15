class Payment < ActiveRecord::Base
  belongs_to :quote
  belongs_to :user
  belongs_to :lawyer
end
