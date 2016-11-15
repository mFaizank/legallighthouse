class ProfileImageUploader < CarrierWave::Uploader::Base
  include UploaderDefaults
  include CarrierWave::MiniMagick

  process resize_to_fill: [250] * 2
end
