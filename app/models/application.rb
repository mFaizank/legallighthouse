class Application < ActiveRecord::Base
  mount_uploader :cv, CVUploader

  def self.years_of_call
    Time.now.year.downto 1960
  end

  store_accessor :data, :firm, :extra_credentials

  validates :first_name, :last_name, :bar_number,
    :year_of_call, :phone_number, :email, :cv, presence: true
  validates :specializations, length: { minimum: 1 }
  validates :email, uniqueness: { allow_blank: true }, if: :email_changed?
  validates :email, format: { with: Devise.email_regexp }, allow_blank: true,
    if: :email_changed?
  validates :bar_number, format: { with: /\A\d{7}\z/ }
  validates :bar_number, uniqueness: true
  validates :year_of_call, inclusion: { in: years_of_call }
  validates :phone_number,
    phone: { message: :invalid_phone }
  validates :good_standing, :malpractice_insurance, :agree, :terms,
    acceptance: { accept: 'true' }

  after_validation :clean_collections
  before_save :normalize_phone_number, :set_locale

  def full_name
    "#{first_name} #{last_name}"
  end

  def status
    if approved_at
      'approved'
    elsif rejected_at
      'rejected'
    else
      'pending'
    end
  end

  def pending?
    !approved_at && !rejected_at
  end

  def approve!
    return if approved_at

    generate_token!
    self.approved_at = Time.now
    save!
  end

  def reject!
    return if rejected_at

    touch :rejected_at
  end

  def other(collection)
    if send(collection).include?('other')
      send(collection).split('other').last
    else
      []
    end
  end

  private

  def clean_collections
    %i(specializations languages).each do |x|
      send :"#{x}=", send(x).delete_if {|y| y.blank? }
    end
  end

  def normalize_phone_number
    self.phone_number = Phonelib.parse(phone_number).sanitized
  end

  def generate_token!
    self.token = SecureRandom.urlsafe_base64(64)
  end

  def set_locale
    self.locale = I18n.locale
  end
end
