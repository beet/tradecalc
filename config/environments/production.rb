# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# memcached
require 'memcache'
CACHE = MemCache.new
CACHE.servers = '127.0.0.1:11211'
config.action_controller.session = {
  :session_key => "_trade_calc_memcached",
  :secret => "someloadofoldbollocksandsuch12",
  :cache => CACHE,
  :expires => 86400 # 24 hour session expirey...
}
memcache_servers = [ '127.0.0.1:11211' ]
config.action_controller.session_store = :mem_cache_store
config.cache_store = :mem_cache_store, '127.0.0.1:11211'

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.action_mailer.smtp_settings = {
  # This setting fixes the "OpenSSL::SSL::SSLError (hostname was not match with the server certificate)" error
  :enable_starttls_auto => false,
  # This setting fixes the "Net::SMTPSyntaxError (501 Syntax: HELO hostname)" error
  :domain => 'tradecalc.com'
}

# Enable threaded mode
# config.threadsafe!