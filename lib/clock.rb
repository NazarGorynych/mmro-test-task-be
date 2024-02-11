# frozen_string_literal: true

require './config/boot'
require './config/environment'
require 'clockwork'

module Clockwork
  configure do |config|
    config[:tz] = 'UTC'
    config[:logger] = Rails.logger
  end

  error_handler do |error|
    Rails.logger.error "Clockwork encountered an unexpected error: #{error.message}"
    Rails.logger.error error.backtrace.join("\n")
  end

  every(1.minute, "Update Auction Status") do
    UpdateAuctionStatusesJob.perform_later
  end
end
