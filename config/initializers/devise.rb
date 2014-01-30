Devise.setup do |config|
  config.secret_key = '17ba7361747afb0f363760b3279610cac7a76d8454e0a33d6d3fc767eebc3240b9a49280c34f05413bbedc6b0c6e90361632044cdaef3ef63bdc6730b6088d19'
  config.mailer_sender = 'rattl@rattl.co.uk'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  require 'omniauth-facebook'
  config.omniauth :facebook, ENV['RATTL_APP_ID'], ENV['RATTL_APP_SECRET'], :strategy_class => OmniAuth::Strategies::Facebook
 end
