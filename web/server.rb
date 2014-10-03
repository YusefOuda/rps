require_relative '../lib/rps.rb'
require_relative '../config/environments.rb'

require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'rack-flash'
require 'pry-byebug'

class RPS::Server < Sinatra::Application
  configure do
    enable :sessions
    use Rack::Session::Cookie, :key => 'rps.session',
                             :path => '/',
                             :expire_after => 31_536_000,
                             :secret => 'rps.secret'
    use Rack::Flash

    set :bind, '0.0.0.0'
  end

  get '/rps' do
    # this page probably needs to have a list of pending games and possibly stats
    if session['rps_session']
      sesh = RPS::Session.find_by(session_id: session['rps_session'])
      @user = sesh.user
      @users = RPS::User.where.not(username: @user.username)
    end
    erb :rps
  end

  get '/rps/match' do
    # display match to user with 3 choices
    id = RPS::Session.find_by(session_id: session['rps_session']).user_id
    params['user1_id'] = id
    result = RPS::CreateMatch.run(params)
    binding.pry
    erb :match
  end

  post '/rps/match' do
    #  (create match if not already exists)
    # check if there are 2 moves and then use transaction script
    # i wrote to determine winner
    # RPS::CreateMatch.run(params)
    erb :match
  end

  get '/signout' do
    sesh = RPS::Session.find_by(session_id: session['rps_session'])
    sesh.destroy
    session.clear
    redirect to '/signin'
  end

  get '/signin' do
    erb :signin
  end

  post '/signin' do
    result = RPS::SigninUser.run(params)

    if !result[:success?]
      flash[:alert] = result[:error]
      redirect to '/signin'
    end

    session_result = RPS::CreateSession.run(result)
    if !session_result[:success?]
      flash[:alert] = session_result[:error]
    end
    session['rps_session'] = session_result[:session_id]
    redirect to '/rps'
  end

  get '/signup' do
    if session['rps_session']
      redirect to '/rps'
    else
      erb :signup
    end
  end

  post '/signup' do
    result = RPS::SignupUser.run(params)

    if !result[:success?]
      flash[:alert] = result[:error]
      redirect to '/signup'
    end
    session_result = RPS::CreateSession.run(result)

    if !session_result[:success?]
      flash[:alert] = session_result[:error]
    end
    session['rps_session'] = session_result[:session_id]
    redirect to '/rps'
  end

  run! if __FILE__ == $0

end