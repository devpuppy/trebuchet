class Trebuchet::Strategy::Base
  
  attr_accessor :feature
  
  def name
    self.class.strategy_name
  end
  
  def self.strategy_name
    Trebuchet::Strategy.name_for_class(self)
  end
  
end