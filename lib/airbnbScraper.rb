require 'nokogiri'
require 'open-uri'
require 'pry'
require 'json'

require_relative './listing.rb' 

class Scraper

  # binding.pry
  
  def self.scrape_data(url)
    Nokogiri::HTML(open(url))
    # print site.css('._18hrqvin').text
  end
  
  def self.get_data
    print 'Paste the Airbnb listing here: '
    url = gets.chomp

    #Creating unique json filename using id from airbnb
    listing_path = self.get_id(url)

    #Creating a new listing instance
    listing = Listing.new

    if File.file?(listing_path)
      file_contents = File.read(listing_path)
      listing.hash = JSON.parse(file_contents)
      
    else

      #Creating a reference so I only obtain the html data once
      html = self.scrape_data(url)


      #Storing key value pairs into the hash
      listing.hash["title"] = html.css('._18hrqvin').first.text
      listing.hash["owner"] = html.css('._8b6uza1').first.text
      listing.hash["location"] = html.css('._czm8crp').first.children.text
      listing.hash["description"] = html.css('#details').css('span').first.text
      listing.hash["attributes"] = html.css('section').css('._n5lh69r').map do |attr| attr.text end
      listing.hash["amenities"] = html.css('._iq8x9is').css('._czm8crp').map do |amenities| amenities.text end

      listing_json = listing.hash.to_json


      File.write(listing_path, listing_json)
    end

   
    return listing
    
  end

  def self.get_id(url)
    filename = url.split('rooms/').last.split('?').first + '.json'
    return path = "./json/#{filename}"
  end
  
end

listing = Scraper.get_data
puts listing.hash

# listing = Scraper.get_data('https://www.airbnb.com/rooms/28299515?location=London%2C%20United%20Kingdom&adults=1&toddlers=0&guests=1&check_in=2019-04-26&check_out=2019-04-30&s=-xq9rVl0')
