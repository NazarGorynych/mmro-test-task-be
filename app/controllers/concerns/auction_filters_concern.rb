# frozen_string_literal: true

module AuctionFiltersConcern
  extend ActiveSupport::Concern

  def filter_auction_scope
    @auctions = @auctions.search(filters:, sort_by:, sort_order:)
  end

  private

  def filters
    params[:filters] || {}
  end

  def sort_by
    params[:sort_by]
  end

  def sort_order
    params[:sort_order] == "asc" ? "asc" : "desc"
  end
end
