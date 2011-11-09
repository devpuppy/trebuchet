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
      method = :"#{strategy.name}_strategy"
      if respond_to?(method)
        send(method, strategy)
      else
        unsupported_strategy(strategy)
      end
    end
    html = if (strategy.name == :multiple)
      html.join('').html_safe # used recursively, so don't wrap outer with <li>
    else
      content_tag(:li, html)
    end
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
    "#{strategy.custom_name} (custom) #{strategy.options.inspect if strategy.options}"
  end
  
  def invalid_strategy(strategy)
    "#{strategy.invalid_name} (invalid) #{strategy.options.inspect if strategy.options}"
  end
  
  def unsupported_strategy(strategy)
    "#{strategy.name} (unsupported)"
  end
  
  def trebuchet_css
    filename = File.expand_path(File.dirname(__FILE__) + "/../views/trebuchet/trebuchet.css")
    return IO.read(filename)
  end
  
end