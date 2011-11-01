require 'nokogiri'
require 'mail'
require 'open-uri'

class RandomLunch
  def initialize
    @api_key = ENV['LD_GOURMET_API_KEY']
    @version = 'v1.0'
    @station_ids = ['2800', '2811'] # hatagaya, hatsudai
    @page = 1
    @entries = 10
    @total_entries = 100
  end

  def sendmail
    restaurants = []

    @station_ids.each do |station_id|
      while @page * @entries < @total_entries
        url = "http://api.gourmet.livedoor.com/#{@version}/restaurant/?api_key=#{@api_key}&station_id=#{station_id}&sort=total"
        doc = Nokogiri::XML(open("#{url}&page=#{@page}"))
        @total_entries = doc.xpath('/results/total_entries').text.to_i

        doc.xpath('/results/restaurant').each do |restaurant|
          restaurants << {:name => restaurant.xpath('name').text,
                          :link => restaurant.xpath('permalink').text}
        end

        @page += 1
      end
    end

    restaurants.shuffle!

    body = ''
    restaurants[0, 10].each_with_index do |restaurant, i|
      body += <<-EOS
    #{i + 1}. #{restaurant[:name]}
    #{restaurant[:link]}

      EOS
    end

    Mail.defaults do
      if ENV['SENDGRID_USERNAME']
        delivery_method :smtp, {
          :address        => 'smtp.sendgrid.net',
          :port           => 25,
          :authentication => 'plain',
          :user_name      => ENV['SENDGRID_USERNAME'],
          :password       => ENV['SENDGRID_PASSWORD'],
          :domain         => ENV['SENDGRID_DOMAIN'],
        }
      else
        delivery_method :sendmail
      end
    end

    mail = Mail.new do
      from    'komagata@gmail.com'
#      to      'komagata@gmail.com,machidanohimitsu@gmail.com'
      to      'komagata@gmail.com'
      subject "Today's recommended restaurants"
      body    body
    end

    mail.deliver
  end
end

RandomLunch.new.sendmail if __FILE__ == $0
