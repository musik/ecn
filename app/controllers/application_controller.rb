class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  before_filter :chose_app
  def chose_app
    @current_app = APPS.select{|k,a| a.domain == request.domain}.first[1] rescue nil
    @current_app = APPS.first[1] if @current_app.nil?
    #logger.debug @current_app
  end
end
