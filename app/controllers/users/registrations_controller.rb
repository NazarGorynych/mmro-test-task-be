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
        email: current_user.email
      }, status: :ok
    else
      render json: {
        status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
