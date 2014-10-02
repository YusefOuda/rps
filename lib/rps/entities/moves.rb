module RPS
  class Move < ActiveRecord::Base
    has_one :user
    has_one :match
  end
end