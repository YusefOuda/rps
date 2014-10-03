module RPS
  class SigninUser
    def self.run(params)
      if params['username'].empty? || params['password'].empty?
        return {success: false, error: "input field(s) empty"}
      end
      user = RPS::User.find_by(username: params['username'])

      if !user
        return {success: false, error: "user not found"}
      end

      if !user.has_password?(params['password'])
        return {success: false, error: "password not correct"}
      end
      user_session = user.sessions.new
      user_session.generate_id
      user_session.save

      {
        success: true,
        user_id: user.id
      }
    end
  end
end