# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  before_action :raise_unauthorized_error
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
  end

  private
  def raise_unauthorized_error
    render json: {message: "User Not Authorized" }, status: 401 unless current_user.present?
  end
end
