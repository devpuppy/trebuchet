require 'digest/md5'

class Trebuchet::Strategy::Percentage < Trebuchet::Strategy::Base

  attr_reader :percentage, :offset

  def initialize(percentage)
    @percentage = percentage
    @offset = 0
    if feature
      # arbitrary yet deterministic offset based on feature name to vary the test groups
      @offset = Digest::MD5.hexdigest(feature.name).to_i(16) % 100
    end
  end

  def launch_at?(user)
    (user.id + @offset) % 100 < percentage
  end

end
