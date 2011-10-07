require 'random_lunch'

desc 'Send random lunch mail'
task :cron do
  now = Time.now
  if (1..5).include?(now.wday) and now.hour == 12
    RandomLunch.new.sendmail
  end
end
