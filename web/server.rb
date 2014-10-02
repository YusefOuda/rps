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
    if session['rps_session']
      sesh = RPS::Session.find_by(session_id: session['rps_session'])
      @user = sesh.user
    end

    @players = RPS::User.where.not(username: @user.username)

    erb :rps
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
    if params['username'].empty? || params['password'].empty?
      flash[:alert] = "Please fill in the required fields"
      redirect to '/signin'
    else
      user = RPS::User.find_by(username: params['username'])
      if user && user.has_password?(params['password'])
        user_session = user.sessions.new
        user_session.generate_id
        user_session.save

        session['rps_session'] = user_session.session_id
        redirect to '/rps'
      else
        flash[:alert] = "Either the password or username was incorrect"
        redirect to '/signin'
      end
    end
  end

  get '/signup' do
    if session['rps_session']
      redirect to '/rps'
    else
      erb :signup
    end
  end

  post '/signup' do
    if params['username'].empty? || params['password'].empty? || params['password-confirm'].empty?
      flash[:alert] = "Please fill in the fields"
      redirect to '/signup'
    end
    if params['password'] == params['password-confirm']
      pw = params['password']
      user = params['username']
      x = RPS::User.new
      x.username = user
      x.update_password(pw)
      x.save
      if x.id == nil
        flash[:alert] = "Username already exists"
        redirect to '/signup'
      else
        user_session = x.sessions.new
        user_session.generate_id
        user_session.save
        session['rps_session'] = user_session.session_id
        redirect to '/rps'
      end
    else
      flash[:alert] = "Passwords didn't match"
      redirect to '/signup'
    end
  end

  run! if __FILE__ == $0

end