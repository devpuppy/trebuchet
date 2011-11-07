module Trebuchet::Strategy

  def self.for_feature(feature)
    strategy_args = Trebuchet.backend.get_strategy(feature.name)
    find(*strategy_args).tap {|s| s.feature = feature }
  end

  def self.find(*args)
    strategy_name, options = args

    if args.size > 2
      Multiple.new(args)
    elsif strategy_name.nil?
      # Strategy hasn't been defined yet
      Default.new
    elsif Custom.exists?(strategy_name)
      Custom.new(strategy_name, options)
    elsif klass = class_for_name(strategy_name)
      klass.new(options)
    # elsif strategy_name == :percent
    #   Percentage.new(options)
    # elsif strategy_name == :users
    #   UserId.new(options)
    else
      raise ArgumentError.new("Unsupported strategy: #{strategy_name}")
    end
  end
  
  def self.name_class_map
    [
      [:percent, Percentage],
      [:users, UserId],
      [:default, Default],
      [:custom, Custom],
      [:multiple, Multiple]
    ]
  end
  
  def self.class_for_name(name)
    classes = Hash[name_class_map]
    classes[name]
  end
  
  def self.name_for_class(klass)
    names = Hash[name_class_map.map(&:reverse)]
    names[klass]
  end

end
