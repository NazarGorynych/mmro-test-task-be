# frozen_string_literal: true

json.members(@members) do |user|
  json.partial! partial: "shared/user", user:
end
