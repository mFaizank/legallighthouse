class Connection < ActiveRecord::Base
  has_many :users
  has_many :lawyers
  has_one :consultation
end
