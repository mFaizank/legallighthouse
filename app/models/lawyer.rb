class Lawyer < ActiveRecord::Base
  mount_uploader :profile_image, ProfileImageUploader
  # def self.search_criteria
  #   %i(search_individual search_specialization search_fixed_fees search_unbundling search_name search_language)
  # end

  attr_accessor :token
  # attr_accessor *search_criteria

  # devise :database_authenticatable, :recoverable, :trackable
  devise :database_authenticatable, :registerable, :rememberable

  has_many :areas, inverse_of: :lawyer
  has_many :services, inverse_of: :lawyer
  has_many :consultations
  has_many :quotes
  has_many :clients
  has_many :payments
  has_many :bank_accounts

  # accepts_nested_attributes_for :areas
  # accepts_nested_attributes_for :services

  validates :consultation_hourly_rate,
    numericality: { greater_than_or_equal_to: 1 }, allow_nil: true
  validates :public_id, uniqueness: true, allow_nil: true

  before_create :import_application, :generate_public_id

  def public_name
    "#{first_name} #{last_name[0]}."
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def avatar
    profile_image.url || 'silhouette.png'
  end

  def profile
    self.becomes(Profile)
  end

  private

  def import_application
    application = Application.find_by(token: @token)

    raise unless application

    application_attributes.each do |a|
      send "#{a}=", application.send(a)
    end

    application.update_attribute :token, nil
  end

  def application_attributes
    %w(first_name last_name bar_number phone_number email languages)
  end

  def generate_public_id
    public_id = [first_name, last_name].map(&:downcase)
      .join('-').gsub(/[^a-zA-Z0-9\-]/, '')
    duplicates = Lawyer.where 'public_id LIKE ?', "#{public_id}%"
    public_id += "-#{duplicates.count + 1}" unless duplicates.empty?
    self.public_id = public_id
  end
end
