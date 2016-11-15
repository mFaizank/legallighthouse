class PhoneNumber
  def self.normalize(phone_number)
    phone_number.gsub! /\D/, ''

    if phone_number.size == 10
      phone_number
    elsif phone_number.size == 11 && phone_number[0] == '1'
      phone_number[1..-1]
    end
  end
end
