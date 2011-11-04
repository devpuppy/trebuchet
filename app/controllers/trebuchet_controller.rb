class TrebuchetController < ::ApplicationController

  def index
    @features = {}
    Trebuchet.backend.get_features.each do |f|
      begin
        @features[f] = Trebuchet::Strategy.for_feature(Trebuchet::Feature.find(f.to_sym))
      rescue ArgumentError
        @features[f] = Trebuchet::Strategy::Default.new
      end
    end
  end
  
end