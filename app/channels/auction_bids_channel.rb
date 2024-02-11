class AuctionBidsChannel < ApplicationCable::Channel

  def subscribed
    auction = Auction.find(params[:id])
    stream_for auction
  end
end
