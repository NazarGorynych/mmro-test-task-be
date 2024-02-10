# frozen_string_literal: true

class Auction < ApplicationRecord
  include AASM

  has_one_attached :main_image, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  belongs_to :user
  has_many :bids, dependent: :destroy
  has_many :members, through: :bids, source: :user
  belongs_to :winner, class_name: "User", optional: true

  enum :bid_type, [:max_win, :sum_win]
  enum :status, [:draft, :active, :completed, :upcoming, :canceled]

  validates_numericality_of :min_bid, allow_nil: false, greater_than: 0
  validates_numericality_of :min_bid_diff, allow_nil: true, greater_than: 0
  after_commit :update_status

  default_scope { where.not(status: :canceled) }

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :active, :completed, :upcoming, :canceled

    event :start do
      transitions from: [:upcoming, :draft], to: :active
    end

    event :setup do
      transitions from: :draft, to: :upcoming
    end

    event :finish do
      transitions from: :active, to: :completed, after: :calculate_winner
    end

    event :cancel do
      transitions from: [:active, :upcoming, :draft], to: :canceled, after: :return_all_bids
    end
  end

  def update_status
    if start_date.present? && (draft? || upcoming?)
      if start_date > Time.current
        setup!
      else
        start!
      end
    end
    if end_date.present? && active? && end_date < Time.current
      finish!
    end
  end

  def search(filters: {}, sort_by: nil, sort_order: nil, include_canceled: false)
    q = all
    q = q.unscoped if include_canceled
    sort_order ||= :desc

    q = apply_filters(q, filters)
    apply_sort_by(q, sort_by, sort_order)
  end

  def apply_filters(q, filters)
    filters.each do |key, value|
      q = apply_filter(q, key, value)
    end
  end

  def self.apply_filter(q, key, value)
    case key&.to_sym
    when :id
    else
      q
    end
  end

  def apply_sort_by(q, sort_by, sort_order)
    sort_by = sort_by&.to_sym
    case sort_by
    when :created_at, :min_bid, :min_bid_diff
      q.order("#{Auction.arel_table[sort_by].send(sort_order).to_sql} NULLS LAST")
    else
      q
    end
  end

  private

  def calculate_winner
    if bid_type == "max_win"
      actual_bids = bids.newest_first.max_by_users
      return_bids(actual_bids[1...])
      self.winner = actual_bids[0].user
    else
      actual_sums = bids.group(:user_id).select("bids.user_id as user_id, SUM(bids.amount) as full_amount")
      max_bid = actual_sums.max_by { |bid| bid.full_amount }
      self.winner_id = max_bid&.user_id
    end
    save!
  end

  def return_all_bids
    if bid_type == "max_win"
      return_bids(bids.max_by_users)
    else
      return_bids(bids)
    end
  end

  def return_bids(bids)
    bids.each do |bid|
      reserved_amount = bid.user.wallet.reserved_amount
      bid.user.wallet.update(reserved_amount: reserved_amount + bid.amount)
    end
  end
end
