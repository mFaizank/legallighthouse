class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable
    # :recoverable, :rememberable, :trackable, :validatable

  # has_many :inquiries
  has_many :consultations
  has_many :quotes
  has_many :payments
  has_many :bank_accounts

  validates :first_name, :last_name, :phone_number, :postal_code,
    presence: true
  validates :name, :title, presence: true, if: :business?
  validates :postal_code, format: /\A[ABCEGHJ-NPRSTVXY][0-9]([ABCEGHJ-NPRSTV-Z]\s*[0-9]){2}\z/i

  def public_name
    business ? name : "#{first_name} #{last_name[0]}."
  end

  def private_name
    business ? name : "#{first_name} #{last_name}"
  end

  def client_of?(lawyer)
    Client.exists?(user: self, lawyer: lawyer)
  end

  def has_quote_from?(lawyer)
    quotes.where(lawyer: lawyer).any?
  end
end
