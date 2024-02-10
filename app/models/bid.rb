# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction

  scope :newest_first, -> () { self.order(created_at: :desc) }
  scope :max_by_users, -> () { self.where(max_by_user: true) }

  validates_numericality_of :amount, greater_than_or_equal_to: :min_bid_value
  validate :reserve_bid_amount
  validate :auction_is_active?
  before_create :set_max_bid

  private

  def auction_is_active?
    unless auction.active?
      errors.add(:base, message: "We can't add bid for not active auction.")
    end
  end

  def set_max_bid
    if auction.bid_type == "max_win"
      auction.bids.where(user:).update_all(max_by_user: false)
      self.max_by_user = true
    end
  end

  def reserve_bid_amount
    if auction.bid_type == "max_win"
      wallet_amount = user.wallet.reserved_amount + (auction.bids.newest_first.where(user_id:).first&.amount || 0)
    else
      wallet_amount = user.wallet.reserved_amount
    end

    if wallet_amount - self.amount >= 0
      user.wallet.update(reserved_amount: wallet_amount - self.amount)
    else
      errors.add(:base, message: "Can't be greater than reserved amount in your wallet!")
    end
  end

  def min_bid_value
    min_bid = auction.bid_type.to_s == "max_win" ? auction.bids.newest_first.first&.amount || auction.min_bid : auction.min_bid
    if auction.min_bid_diff.present? && min_bid != auction.min_bid
      min_bid += auction.min_bid_diff
    end
    min_bid
  end
end
