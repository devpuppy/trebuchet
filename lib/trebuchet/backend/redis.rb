require 'redis'
require 'json'

class Trebuchet::Backend::Redis
  
  attr_accessor :namespace
  
  def initialize(*args)
    @redis = Redis.new(*args)
    @namespace = 'trebuchet/'
  end

  def get_strategy(feature_name)
    return nil unless h = @redis.hgetall(feature_key(feature_name))
    [].tap do |a|
      h.each do |k, v|
        a << k.to_sym
        a << JSON.load(v).first # unpack from array
      end
    end
  end

  def set_strategy(feature_name, strategy, options = nil)
    @redis.del(feature_key(feature_name))
    append_strategy(feature_name, strategy, options)
  end

  def append_strategy(feature_name, strategy, options = nil)
    @redis.hset(feature_key(feature_name), strategy, [options].to_json) # have to put options in container for json
    @redis.sadd(feature_names_key, feature_name)
  end
  
  def get_feature_names
    @redis.smembers(feature_names_key)
  end

  private
  
  def feature_names_key
    "#{namespace}feature-names"
  end
  
  def feature_key(feature_name)
    '#{namespace}features/#{feature_name}'
  end

end
