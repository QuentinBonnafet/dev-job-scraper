require 'httparty'
require 'nokogiri'
require 'byebug'

def scraper
  url = "https://welovedevs.com/app/fr/jobs"
  # url_other_version = "https://welovedevs.com/app/fr/jobs?page=1"
  unparsed_page = HTTParty.get(url)
  if unparsed_page.nil? || unparsed_page.body.nil? || unparsed_page.body.empty?
    return nil
  end
  # https://github.com/jnunemaker/httparty/issues/568
  # https://github.com/jnunemaker/httparty/pull/676
  parsed_page = Nokogiri::HTML(unparsed_page)
  job_offers = []
  job_cards = parsed_page.css('div.jss179')

  page = 1

  job_cards_per_page = job_cards.count

  nb_of_job_cards_text = parsed_page.css('h1').text
  total_of_job_cards = nb_of_job_cards_text.split.first.to_i
  # if "," or "." present in the result use .gsub method to clean integer

  last_page = (total_of_job_cards.to_f / job_cards_per_page.to_f).ceil

  while page <= last_page
    pagination_url = "https://welovedevs.com/app/fr/jobs?page=#{page}&searchRadius=30"
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
    pagination_job_cards = pagination_parsed_page.css('div.jss179')
    pagination_job_cards.each do |job_card|
      job = {
        job_title: job_card.css('div.jss184').text,
        jod_location: job_card.css('div.jss190').text,
        job__creation: job_card.css('span.jss49').text
      }
      job_offers << job
    end
    page += 1
  end
  byebug
end

scraper