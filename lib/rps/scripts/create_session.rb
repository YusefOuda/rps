module RPS
  class CreateSession
    def self.run(params)
      user = RPS::User.find(params[:user_id])
      user_session = user.sessions.new
      user_session.generate_id
      user_session.save
      if user_session.id.nil?
        return {success: false, error: "could not create session"}
      end
      {
        success: true,
        session_id: user_session.session_id
      }
    end
  end
end