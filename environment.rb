require 'bundler/setup'
Bundler.require
$:.unshift File.expand_path('..', __FILE__)
Dotenv.load

configure do
  use Rack::Flash, :accessorize => [:notice, :error]
  set :session_secret, ENV.fetch('SESSION_SECRET')
  enable :sessions
  enable :logging
  enable :method_override
  disable :dump_errors
  disable :raise_errors
  disable :show_exceptions
end

configure :development do
  require 'pry-byebug'
  use Rack::Reloader
end
