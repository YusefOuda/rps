require 'active_record'
module RPS

end

require_relative './rps/entities/match.rb'
require_relative './rps/entities/user.rb'
require_relative './rps/entities/session.rb'
require_relative './rps/scripts/signup_user.rb'
require_relative './rps/scripts/create_session.rb'
require_relative './rps/scripts/signin_user.rb'
require_relative './rps/scripts/create_match.rb'