class Client < ActiveRecord::Base
  enum status: %i(pending active inactive)

  belongs_to :user
  belongs_to :lawyer

  validates :user, :lawyer, presence: true

  def name
    user.private_name
  end
end
