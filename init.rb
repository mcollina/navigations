
config.to_prepare do
  ActionController::Base.send :include, Navigations::Navigable
end