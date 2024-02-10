# frozen_string_literal: true

json.extract! user, :name, :email
json.avatar_url user.avatar.attached? ? url_for(user.avatar) : nil
