require 'digest/sha1'

class Trebuchet::Strategy::Experiment < Trebuchet::Strategy::Base

  attr_reader :bucket, :total_buckets, :name

  def initialize(options = {})
    @name = options[:name]
    @bucket = [ options[:bucket] ].flatten # always treat as an array
    @total_buckets = options[:total_buckets] || 5
  end

  def launch_at?(user)
    # must hash feature name and user id together to ensure uniform distribution
    b = Digest::SHA1.hexdigest("experiment: #{@name.downcase} user: #{user.id}").to_i(16) % total_buckets
    !!@bucket.include?(b + 1) # is user in this bucket?
  end

end