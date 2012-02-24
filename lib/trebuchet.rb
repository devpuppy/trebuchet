class Trebuchet

  @@visitor_id = nil

  class << self
    attr_accessor :admin_view, :admin_edit
    
    def backend
      self.backend = :memory unless @backend
      @backend
    end
    
    def set_backend(backend_type, *args)
      require "trebuchet/backend/#{backend_type}"
      @backend = Backend.lookup(backend_type).new(*args)
    end
    
    # this only works with additional args, e.g.: Trebuchet.backend = :memory
    alias_method :backend=, :set_backend 
    
  end

  def self.aim(feature_name, *args)
    Feature.find(feature_name).aim(*args)
  end

  def self.define_strategy(name, &block)
    Strategy::Custom.define(name, block)
  end

  def self.visitor_id=(id_or_proc)
    if id_or_proc.is_a?(Proc)
      @@visitor_id = id_or_proc
    elsif id_or_proc.is_a?(Integer)
      @@visitor_id = proc { |request| id_or_proc }
    else
      @@visitor_id = nil
    end
  end

  def self.visitor_id
    @@visitor_id
  end

  def self.feature(name)
    Feature.find(name)
  end

  def initialize(current_user, request = nil)
    @current_user = current_user
    @request = request
  end

  def launch(feature, &block)
    yield if launch?(feature)
  end

  def launch?(feature)
    Feature.find(feature).launch_at?(@current_user, @request)
  end

end

# FIXME: this makes the entire gem dependent on Rails 3
require 'trebuchet/engine' 

require 'set'
require 'trebuchet/version'
require 'trebuchet/error'
require 'trebuchet/backend'
require 'trebuchet/backend/disabled'
# load other backends on demand so their dependencies can load first
require 'trebuchet/feature'
require 'trebuchet/strategy'
require 'trebuchet/strategy/base'
require 'trebuchet/strategy/default'
require 'trebuchet/strategy/percentage'
require 'trebuchet/strategy/user_id'
require 'trebuchet/strategy/experiment'
require 'trebuchet/strategy/custom'
require 'trebuchet/strategy/invalid'
require 'trebuchet/strategy/multiple'
require 'trebuchet/strategy/visitor_percent'

require 'trebuchet/railtie' if defined?(Rails)
