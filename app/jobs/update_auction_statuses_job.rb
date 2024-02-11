# frozen_string_literal: true

class UpdateAuctionStatusesJob < ApplicationJob

  def perform
    Auction.all.find_each do |auction|
      auction.update_status
    end
  end
end
