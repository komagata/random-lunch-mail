require 'rubygems'
require 'bundler/setup'
require './random_lunch'
require 'clockwork'
include Clockwork

handler do |job|
  RandomLunch.new.sendmail
end

every 1.days, 'sendmail', :at => '12:00'
