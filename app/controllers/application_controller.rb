# frozen_string_literal: true

class ApplicationController < ActionController::API
  respond_to :json
  before_action :raise_unauthorized_error
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :raise_unauthorized_error, if: :devise_controller?
  after_action :run_auction_jobs

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
  end

  def run_auction_jobs
    UpdateAuctionStatusesJob.perform_later # temporary solution to not deploy cron job
  end

  private
  def raise_unauthorized_error
    render json: {message: "User Not Authorized" }, status: 401 unless current_user.present?
  end
end
