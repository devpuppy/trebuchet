require 'redis'
require 'json'

class Trebuchet::Backend::Redis

  attr_accessor :namespace

  def initialize(*args)
    @redis = Redis.new(*args)
    @namespace = 'trebuchet/'
  end

  def get_strategy(feature_name)
    JSON.load @redis.get(key(feature_name))
  end

  def set_strategy(feature_name, strategy, options = nil)
    @redis.set(key(feature_name), [strategy, options].to_json)
  end

  def append_strategy(feature_name, strategy, options = nil)
    @redis.set(key(feature_name), (get_strategy(feature_name) + [strategy, options]).to_json)
  end

  private

  def key(feature_name)
    "#{namespace}#{feature_name}"
  end

end
