# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsStore
  respond_to :json
  skip_before_action :raise_unauthorized_error

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        status: 200,
        message: 'Signed up successfully.',
        email: current_user.email,
        jti: current_user.jti
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
