if Rails::VERSION::STRING =~ /\A2\./

  ActionController::Routing::Routes.draw do |map|
    map.trebuchet '/trebuchet', :controller => 'trebuchet'
  end

else

  Rails.application.routes.draw do
    get "trebuchet" => "trebuchet#index" , :as => :trebuchet
  end

end