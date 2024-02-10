# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  before_action :raise_unauthorized_error

  private
  def raise_unauthorized_error
    render json: {message: "User Not Authorized" }, status: 401 unless current_user.present?
  end
end
