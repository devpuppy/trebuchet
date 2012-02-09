if Rails::VERSION::MAJOR == 3
  
  Rails.application.routes.draw do
    get "trebuchet" => "trebuchet#index" , :as => :trebuchet
  end
  
else
  
  ActionController::Routing::Routes.draw do |map|
    map.trebuchet '/trebuchet.:format', :controller => 'trebuchet'
  end
  
end