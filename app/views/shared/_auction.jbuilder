# frozen_string_literal: true

json.extract! decorated_auction, :title, :description, :min_bid, :min_bid_diff, :bid_type, :status,
                                                    :start_date, :end_date, :winner_bid_amount, :winner, :total_donated,
                                                    :max_bid_amount, :max_bid_user_name
if with_images
  json.images decorated_auction.images.attached? ? decorated_auction.images.map { |img| url_for(img) } : []
  json.main_image decorated_auction.main_image.attached? ? url_for(decorated_auction.main_image) : nil
end
