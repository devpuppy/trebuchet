require 'digest/sha1'

class Trebuchet::Strategy::Bucket < Trebuchet::Strategy::Base

  attr_reader :bucket, :bucket_count

  def initialize(options = {})
    if (n = options).is_a?(Integer)
      options = {}
      options[:bucket] = n
    end
    @experiment = options[:experiment] || ""
    @bucket = options[:bucket]
    @bucket_count = options[:bucket_count] || 10
  end

  def launch_at?(user)
    # must hash feature name and user id together to ensure uniform distribution
    b = Digest::SHA1.hexdigest("experiment: #{@experiment.downcase} user: #{user.id}").to_i(16) % bucket_count
    !!(b + 1 == @bucket) # is user in this bucket?
  end

end