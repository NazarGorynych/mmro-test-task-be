# frozen_string_literal: true

class Auctions::MembersController < ApplicationController
  skip_before_action :raise_unauthorized_error

  def index
    @members = Auction.find(params[:auction_id]).members
  end
end
