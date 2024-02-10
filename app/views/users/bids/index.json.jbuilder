# frozen_string_literal: true

json.bids(@bids) do |bid|
  json.partial!(partial: 'shared/bid', bid:)
  json.auction_title bid.auction.title
end
