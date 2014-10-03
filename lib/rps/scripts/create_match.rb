module RPS
  class CreateMatch
    def self.run(params)
      match = RPS::Match.new
      match.player1_id = params['user1_id']
      match.player2_id = params['id']
      match.save
      {
        success?: true,
        match_id: match.id
      }
    end
  end
end