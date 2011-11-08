class TrebuchetController < ::ApplicationController

  def index
    @features = Trebuchet::Feature.all
    @features.sort! {|x,y| x.name.downcase <=> y.name.downcase }
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.json { render :json => @features }
    end
  end
  
end