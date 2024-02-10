# frozen_string_literal: true

class Users::AuctionsController < ApplicationController

  before_action :set_auctions_scope

  def index
    @auctions.preload(:winner, bids: :user)
  end

  def show
    @auction = @auctions.find(params[:id])
  end

  def update
    @auction = @auctions.find(params[:id])
    @auction.update!(auction_params)
    attach_images
  end

  def create
    @auction = @auctions.create!(auction_params.merge(images_params))
  end

  def destroy
    @auction = @auctions.find(params[:id])
    @auction.cancel!
    render json: { message: "Deleted" }
  end

  def finish
    @auction = @auctions.find(params[:id])
    unless @auction.active?
      render json: { message: "Can't finish not active auction" }, status: :bad_request and return
    end
    @auction.finish!
    render json: { message: "Finished" }
  end

  private

  def attach_images
    if ActiveModel::Type::Boolean.new.cast(params[:drop_old_images])
      @auction.images.purge_later
    end
    @auction.images.attach(images_params[:images])
    @auction.main_image.attach(images_params[:main_image])
  end

  def images_params
    params.permit(:main_image, images: [])
  end

  def auction_params
    params.permit(:title, :description, :min_bid, :min_bid_diff, :bid_type, :start_date, :end_date)
  end

  def set_auctions_scope
    @auctions = current_user.auctions
  end
end
