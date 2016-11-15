class Profile < Lawyer
  def list!
    update_attribute :listed, true if complete?
  end

  def unlist!
    update_attribute :listed, false
  end

  def complete?
    [
      profile_image.url,
      designation,
      location,
      years_of_experience,
      bio,
      services.first
    ].all? { |x| !x.blank? }
  end
end
