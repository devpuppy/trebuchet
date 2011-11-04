module TrebuchetHelper

  def feature(feature)
    "<dd>#{feature.name}</dd>
    <dt><ul>#{strategy feature.strategy}</ul></dt>"
  end
  
  def strategy(strategy)
    html = case strategy.name
    when nil
      default_strategy(strategy)
    else
      send(:"#{strategy.name}_strategy", strategy)
    end
    strategy.name == :multiple ? html : "<li>#{html}</li>"
  end
  
  def users_strategy(strategy)
    "user ids: #{strategy.user_ids.to_a.join(', ')}"
  end
  
  def percent_strategy(strategy)
    low_id = 0.to_s.rjust(2, '0')
    high_id = (strategy.percentage - 1).to_s.rjust(2, '0')
    "#{strategy.percentage}% (user id ending with #{low_id}#{" to #{high_id}" if high_id != low_id})"
  end
  
  def multiple_strategy(strategy)
    strategy.strategies.map do |s|
      strategy s
    end
  end
  
  def default_strategy(strategy)
    "feature not launched"
  end
  
  def custom_strategy(strategy)
    "#{strategy.custom_name} (custom strategy) #{strategy.options.inspect if strategy.options}"
  end
  
end