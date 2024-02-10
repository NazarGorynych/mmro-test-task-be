# frozen_string_literal: true

json.profile do
  json.partial! partial: 'shared/user', user: current_user
end
