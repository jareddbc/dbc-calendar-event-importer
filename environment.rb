require 'bundler/setup'
Bundler.require
require 'pry-byebug'
$:.unshift File.expand_path('..', __FILE__)
Dotenv.load

configure do
  set :session_secret, ENV.fetch('SESSION_SECRET')
  enable :sessions
  enable :logging
  set :method_override, true
end

configure :development do
  use Rack::Reloader
end
