class TrebuchetController < ::ApplicationController

  def index
    @features = {}
    Trebuchet.backend.get_features.each do |f|
      @features[f] = Trebuchet.backend.get_strategy(f)
    end
    # raise @features.inspect
  end
  
end