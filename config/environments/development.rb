# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
#config.cache_classes = true
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
#config.action_controller.perform_caching             = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = true

ExceptionNotifier.exception_recipients = %w(bryan.ray@datacert.com)

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

config.action_mailer.raise_delivery_errors = true
ActionMailer::Base.default_charset    = 'utf-8'
ActionMailer::Base.delivery_method    = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings    = {
  :address => 'DCMX01.DC.COM'
}
