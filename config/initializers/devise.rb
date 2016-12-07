# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.secret_key = '6bf3d42ac5e1e27d76035c3aff83d9c942fd127ab1111542470becaa9bd4242e128fe9c8b7466f666ffaf4bbfed3266e4f755ca69f05e5501c3fac5b994cb1a2' if Rails.env.production?

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/


  config.reset_password_within = 6.hours

  config.sign_out_via = :delete

end
