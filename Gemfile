source "http://rubygems.org"

ruby "2.3.0"

# gem "airbrake"
gem "autoprefixer-rails"
gem "bourbon", "~> 4.2.0"
gem "carrierwave"
gem "client_side_validations"
gem "coffee-rails", "~> 4.1.0"
gem "delayed_job_active_record"
gem "devise", "~> 3.5"
gem "flutie"
gem "high_voltage"
gem "jquery-rails"
gem "language_list"
gem "mini_magick"
gem "neat", "~> 1.7.0"
gem "newrelic_rpm", ">= 3.9.8"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "phonelib"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 4.2.0"
gem "recipient_interceptor"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "stripe"
gem "client_side_validations-simple_form"
gem "title"
gem "uglifier"

group :development do
  gem 'tzinfo-data'
  gem "quiet_assets"
  gem "refills"
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.4.0"
end

group :test do
  # gem "capybara-webkit"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "fog", require: "fog/aws"
  gem "rails_stdout_logging"
  gem "rack-timeout"
end
