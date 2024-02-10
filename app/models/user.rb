# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_one_attached :avatar, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :wallet, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :auctions, dependent: :destroy

  after_commit :create_wallet, on: :create
end
