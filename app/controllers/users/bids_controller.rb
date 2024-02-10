# frozen_string_literal: true

class Users::BidsController < ApplicationController
  def index
    @bids = current_user.bids.newest_first.preload(:auction)
  end
end
