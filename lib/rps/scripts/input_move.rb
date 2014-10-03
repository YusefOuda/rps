module RPS
  class InputMove
    def self.run(params)
      p1_move = params['player1_move']
      p2_move = params['player2_move']
      beats = {
       :scissors => :rock,
       :paper => :scissors,
       :rock => :paper
      }

      if p1_move == beats[p2_move]
       return {success?: true, winner: 'player_1'}
      elsif p2_move == beats[p1_move]
       return {success?: true, winner: 'player_2'}
      else
       return {success?: true, winner: 'draw'}
      end

      {success?: false, error: "unknown error"}
    end
  end
end