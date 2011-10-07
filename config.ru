require 'rubygems'
require 'bundler'
Bundler.setup

class App
  def call(env)
    [200, {'Content-Type' => 'text/plain'}, ['This app is executed by cron only.']]
  end
end

run App.new
