class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def not_found
    raise ActiveRecord::RecordNotFound, 'Not Found'
  end

  def after_sign_in_path_for(_resource)
    if resource.class == AdminUser
      admin_dashboard_path
    else
      user_products_path
    end
  end

  def after_sign_out_path_for(_resource)
    if resource.class == AdminUser
      admin_root_path
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :slack_user])
  end
end
