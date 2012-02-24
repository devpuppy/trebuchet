require 'rails'

class Trebuchet
  class Engine < ::Rails::Engine

    initializer "trebuchet.action_controller" do
      ActiveSupport.on_load :action_controller do
        require 'trebuchet/action_controller'
        include Trebuchet::ActionController
      end
    end

  end
end