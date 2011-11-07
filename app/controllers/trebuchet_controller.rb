class TrebuchetController < ::ApplicationController

  def index
    @features = Trebuchet::Feature.all
    @features.reject! {|f| f.valid? == false}
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.json { render :json => @features }
    end
  end
  
end