class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  before_filter :set_configurations

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  	def set_configurations
      if current_user.nil?
        @configurations = StoreConfiguration.find(3)
      else
         @configurations = StoreConfiguration.where(:user_id => current_user.user_id).first
      end
    end

end
