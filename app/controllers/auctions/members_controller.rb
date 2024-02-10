# frozen_string_literal: true

class Auctions::MembersController < ApplicationController
  def index
    @members = Auction.find(params[:auction_id]).members
  end
end
