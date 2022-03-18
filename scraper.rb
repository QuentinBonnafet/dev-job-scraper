require 'httparty'
require 'nokogiri'
require 'byebug'

def scraper
  url = "https://welovedevs.com/app/fr/jobs"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  job_offers = []
  job_cards = parsed_page.css('div.jss179')
  job_cards.each do |job_card|
    job = {
      job_title: job_card.css('div.jss184').text,
      jod_location: job_card.css('div.jss190').text,
      job__creation: job_card.css('span.jss49').text
    }
    job_offers << job
  end
end

scraper