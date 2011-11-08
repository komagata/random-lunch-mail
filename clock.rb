require 'rubygems'
require 'bundler/setup'
require './random_lunch'
require './date_ext'
require 'clockwork'
include Clockwork

handler do |job|
end

every 1.days, 'sendmail', :at => '12:00' do
  RandomLunch.new.sendmail if Date.today.weekday?
end
