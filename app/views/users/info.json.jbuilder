# frozen_string_literal: true

json.profile do
  json.partial! partial: 'shared/user', user: current_user
end

json.wallet_amount current_user.wallet.amount
json.wallet_reserved_amount current_user.wallet.reserved_amount
