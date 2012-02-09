require 'spec_helper'

describe Trebuchet::Strategy::VisitorPercent do

  # Implements Rack's #session_options and sets #session_options[:id] to the
  # ID sent at initialization
  class MockRackRequest
    attr_accessor :session_options

    def initialize session_id
      @session_options = {:id => session_id}
    end
  end

  it 'should not launch if no request is present' do
    Trebuchet.aim('some_feature', :visitor_percent, 100)
    should_not_launch('some_feature', [1000])
  end

  it 'should launch to a valid session' do
    Trebuchet.aim('some_feature', :visitor_percent, 100)
    t = Trebuchet.new(User.new(0), MockRackRequest.new('12345'))
    t.launch?('some_feature').should === true
  end

  it 'should not launch to a nil session ID' do
    Trebuchet.aim('some_feature', :visitor_percent, 100)
    t = Trebuchet.new(User.new(0), MockRackRequest.new(nil))
    t.launch?('some_feature').should === false
  end

  it 'should not launch to an empty session ID' do
    Trebuchet.aim('some_feature', :visitor_percent, 100)
    t = Trebuchet.new(User.new(0), MockRackRequest.new(''))
    t.launch?('some_feature').should === false
  end

  it 'should not launch to a bogus, non-hex session ID' do
    Trebuchet.aim('some_feature', :visitor_percent, 100)
    t = Trebuchet.new(User.new(0), MockRackRequest.new('My Name is Bob'))
    t.launch?('some_feature').should === false
  end

end
