module RPS
  class SignupUser
    def self.run(params)
      if params['username'].empty? || params['password'].empty? || params['password-confirm'].empty?
        return {success?: false, error: "input field(s) empty"}
      end
      if params['password'] == params['password-confirm']
        pw = params['password']
        user = params['username']
        x = RPS::User.new
        x.username = user
        x.update_password(pw)
        x.save
        if x.id == nil
          return {success?: false, error: "username already exists"}
        end
      else
        return {success?: false, error: "passwords didn't match"}
      end
      {
        success?: true,
        user_id: x.id
      }
    end
  end
end