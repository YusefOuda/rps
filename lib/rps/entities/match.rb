module RPS
  class Match < ActiveRecord::Base
    has_many :moves
  end
end