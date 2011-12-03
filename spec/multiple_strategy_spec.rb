require 'spec_helper'

describe Trebuchet::Strategy::Multiple do

  it "should support chaining strategies" do
    Trebuchet.feature('time_machine').aim(:percent, 10).aim(:users, [10, 11])
    offset = 72 # for "time_machine"
    should_launch('time_machine', [0-offset, 9-offset, 10, 11])
    should_not_launch('time_machine', [23, 42])
  end
  
  it "should always return booleans" do
    Trebuchet.feature('time_machine').aim(:percent, 0).aim(:users, [5])
    t = Trebuchet.new User.new(5)
    t.launch?('time_machine').should === true
    t = Trebuchet.new User.new(117)
    t.launch?('time_machine').should === false
  end
  
  it "should set @feature on sub-strategies" do
    feature = Trebuchet.feature('time_machine')
    feature.aim(:percent, 10).aim(:users, [5])
    feature.strategy.feature.name == feature.name
    feature.strategy.strategies.first.feature.name.should == feature.name
    feature.strategy.strategies.last.feature.name.should == feature.name
  end

end
