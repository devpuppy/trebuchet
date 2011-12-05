require 'spec_helper'

describe Trebuchet::Strategy::Bucket do
  
  before do
    @feature_name = 'Button Color'
  end
  
  it "should match a user in a bucket" do
    Trebuchet.aim(@feature_name, :bucket, 1)
    strategy = Trebuchet.feature(@feature_name).strategy
    # these values just happen to hash for the algorithm and feature name
    strategy.launch_at?(User.new(4)).should be_true
    strategy.launch_at?(User.new(5)).should be_false
  end
  
  it "should adjust the number of buckets" do
    Trebuchet.aim(@feature_name, :bucket, {:bucket => 1, :bucket_count => 3})
    strategy = Trebuchet.feature(@feature_name).strategy
    strategy.bucket_count.should == 3
    strategy.bucket.should == 1
    strategy.launch_at?(User.new(4)).should be_true
    Trebuchet.aim(@feature_name, :bucket, {:bucket => 2, :bucket_count => 3})
    Trebuchet.feature(@feature_name).strategy.launch_at?(User.new(4)).should be_false
  end
  
  it "should be mutually exclusive within experiments" do
    strategies = (1..10).map do |i|
      Trebuchet.aim(@feature_name, :bucket, i)
      Trebuchet.feature(@feature_name).strategy
    end
    user_ids = (1..100).to_a
    launches = strategies.map do |strategy|
      user_ids.select {|user_id| strategy.launch_at?(User.new(user_id))}
    end
    occurrences = user_ids.map do |user_id|
      launches.select{|l| l.include?(user_id)}.size
    end
    # no user should be in more than one bucket
    occurrences.select{|i| i > 1}.size.should == 0
    # each user should be in one bucket
    occurrences.select{|i| i < 1}.size.should == 0
  end
  
  it "should distribute users evenly" do
    Trebuchet.aim(@feature_name, :bucket, 5)
    strategy = Trebuchet.feature(@feature_name).strategy
    user_ids = (1..10_000).to_a
    launches = user_ids.map {|user_id| strategy.launch_at?(User.new(user_id))}
    # total should be around 10%
    launch_count = launches.select{|l| l == true}.size
    (launch_count * 100 / user_ids.size).round.should == 10
  end
  
  it "should have low overlap between experiments" do
    other_feature_name = 'Eternal Youth'
    another_feature_name = 'Invisibility'
    Trebuchet.aim(@feature_name, :bucket, 3)
    Trebuchet.aim(other_feature_name, :bucket, 5)
    Trebuchet.aim(another_feature_name, :bucket, 7)
    strategies = [
      Trebuchet.feature(@feature_name).strategy,
      Trebuchet.feature(other_feature_name).strategy,
      Trebuchet.feature(another_feature_name).strategy
    ]
    # find out which users match each strategy
    user_ids = (1..10_000).to_a
    launches = strategies.map do |strategy|
      user_ids.select {|user_id| strategy.launch_at?(User.new(user_id))}
    end
    # intersect each set with the next
    overlaps = []
    (0..launches.size).each do |i|
      j = (i + 1) % launches.size
      overlaps << launches[i] & launches[j]
    end
    # each group should have about 10% overlap
    ((9..11) === (overlaps[0].size * 100 / user_ids.size).round).should be_true
    ((9..11) === (overlaps[1].size * 100 / user_ids.size).round).should be_true
    ((9..11) === (overlaps[2].size * 100 / user_ids.size).round).should be_true
    # 1% or fewer of users should be in all three groups
    total_overlap = (launches[0] & launches[1] & launches[2])    
    (total_overlap.size * 100 / user_ids.size).round.should < 2
  end
   
end