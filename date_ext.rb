require 'date'

class Date
  def weekday?
    (1..5).include?(wday)
  end
end
