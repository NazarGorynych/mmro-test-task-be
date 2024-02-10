# frozen_string_literal: true

class UsersController < ApplicationController

  def info;end

  def update
    current_user.update(params.permit(:name))
    current_user.avatar.attach(params[:avatar]) if params[:avatar].present?
  end

  def replenish
    wallet = current_user.wallet
    wallet.add_amount(params[:amount])
    wallet.save!
    render json: { amount: wallet.amount, reserved_amount: wallet.reserved_amount }
  end
end
