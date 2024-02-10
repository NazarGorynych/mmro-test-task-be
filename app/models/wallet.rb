# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user
  before_create :setup_amounts

  validates_uniqueness_of :user_id

  def add_amount(value)
    value = value.to_f
    self.amount += value
    self.reserved_amount += value
  end

  private

  def setup_amounts
    self.amount ||= 0
    self.reserved_amount = self.amount
  end
end
