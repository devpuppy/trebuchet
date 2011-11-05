# Default is to not launch the feature to anyone
class Trebuchet::Strategy::Default < Trebuchet::Strategy::Base

  def name
    :default
  end

  def launch_at?(user)
    false
  end
  
end
