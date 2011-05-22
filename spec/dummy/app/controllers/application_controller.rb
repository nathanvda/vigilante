class ApplicationController < ActionController::Base
  protect_from_forgery

  protected_by_vigilante
end
