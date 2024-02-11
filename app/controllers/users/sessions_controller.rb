# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsStore
  respond_to :json
  skip_before_action :raise_unauthorized_error

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        status: 200,
        message: 'Logged in successfully.',
        email: current_user.email,
        jti: current_user.jti
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, ENV['DEVICE_SECRET_KEY']).first
      current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
