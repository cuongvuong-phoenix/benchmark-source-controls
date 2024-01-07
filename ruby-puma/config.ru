require 'rubygems' unless defined? Gem
require "#{File.dirname(__FILE__)}/app"

set :logging, false
set :environment, :production
set :protection, except: :path_traversal

run Sinatra::Application
