# frozen_string_literal: true

json.bids(@bids) do |bid|
  json.partial!(partial: 'shared/bid', bid:)
  json.bid_author do
    json.partial!(partial: 'shared/user', user: bid.user)
  end
end
