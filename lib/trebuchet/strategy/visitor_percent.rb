class Trebuchet::Strategy::VisitorPercent < Trebuchet::Strategy::Base

  attr_reader :percent

  def initialize(percent)
    @percent = percent
  end
  
  def offset
    feature_id % 100
  end

  def launch_at?(user, request = nil)
    session_id = request.respond_to?(:session_options) &&
      request.session_options[:id]

    if !session_id || session_id == ''
      false
    else
      session_id_int = session_id.hex
      session_id_int > 0 &&
        (session_id_int + offset) % 100 < percent
    end
  end

end
