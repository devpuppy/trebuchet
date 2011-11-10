class TrebuchetController < ApplicationController
  
  before_filter :control_access

  def index
    @features = Trebuchet::Feature.all
    @features.sort! {|x,y| x.name.downcase <=> y.name.downcase }
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.json { render :json => @features }
    end
  end
  
  private
  def control_access
    key = "trebuchet/#{params[:action]}"
    if Trebuchet::Feature.exist?(key)
      unless trebuchet.launch?(key)
        raise ActionController::RoutingError.new('Not Found')
      end
    end
    return true
  end
  
end