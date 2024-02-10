# frozen_string_literal: true

json.auctions(AuctionDecorator.decorated_scope @auctions) do |decorated_auction|
  json.partial!(partial: "shared/auction", with_images: true, decorated_auction:)
end
