class Trebuchet::Strategy::Percentage

  attr_reader :percentage

  def initialize(percentage)
    @percentage = percentage
  end
  
  def name
    :percent
  end

  def launch_at?(user)
    user.id % 100 < percentage
  end

end
