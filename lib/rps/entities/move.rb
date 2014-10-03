module RPS
  class Move < ActiveRecord::Base
    belongs_to :user
    belongs_to :match
  end
end