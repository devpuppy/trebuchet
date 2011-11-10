require 'redis'
require 'json'

class Trebuchet::Backend::Redis
  
  attr_accessor :namespace
  
  def initialize(*args)
    @redis = Redis.new(*args)
    @namespace = 'trebuchet/'
  end

  def get_strategy(feature_name)
    if s = @redis.hget(key, feature_name)
      s = JSON.load(s)
      s.map! {|e| e && s.index(e).even? ? e.to_sym : e} # set strategy names to symbols
    else
      nil
    end
  end

  def set_strategy(feature_name, strategy, options = nil)
    @redis.hset(key, feature_name, [strategy, options].to_json)
  end

  def append_strategy(feature_name, strategy, options = nil)
    s = get_strategy(feature_name) || []
    @redis.hset(key, feature_name, (s + [strategy, options]).to_json)
  end
  
  def get_feature_names
    @redis.hkeys(key)
  end

  private

  def key
    '#{namespace}features'
  end

end
