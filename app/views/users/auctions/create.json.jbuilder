# frozen_string_literal: true

json.partial!(partial: "shared/auction", decorated_auction: AuctionDecorator.new(@auction), with_images: true)
