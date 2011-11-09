require 'trebuchet'

if defined? Rails
  Trebuchet.use_with_rails!
  
  if Rails.respond_to?(:version) && Rails.version =~ /^3/
    # Rails 3.x
    # use Railtie
  else
    # Rails 2.x
    config ||= Rails.configuration if Rails.respond_to?(:configuration)
    config.gem 'trebuchet' # load as engine even if loaded via bundler
    load_paths.each do |path|
       ActiveSupport::Dependencies.load_once_paths.delete(path)
    end if config.environment == 'development'
  end
end