# frozen_string_literal: true

require './config/boot'
require './config/environment'
require 'clockwork'

module Clockwork
  configure do |config|
    config[:logger] = Rails.logger
    config[:tz] = 'America/New_York'
  end

  error_handler do |error|
    Rails.logger.error "Clockwork encountered an unexpected error: #{error.message}"
    Rails.logger.error error.backtrace.join("\n")
  end

  every(15.min, "Update Auction Status") do

  end
end
