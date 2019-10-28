require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  @@resorts_array = []
  
  def self.scrape_destinations_page(destinations_url)
    
    html = open(destinations_url)
    doc = Nokogiri::HTML(html)
    
    binding.pry
    doc.css("li.hover-on dvcDestinationsListListingItem dvcss-listing-item clearfix panel").each do |each_resort| 
    resort_summary = {}

      resort_summary[:resort_url] = each_resort.css("a.dvcss-listing-item-card-description clickable").attribute("href").value
      resort_summary[:resort_name] = each_resort.css("a.dvcss-listing-item-card-description clickable").attribute("label").value
      @@resorts_array << resort_summary
    end #each
    @@resorts_array
  end #scrape_destinations_page

  def self.scrape_resort_page(resort_url)
    @@resort_details_hash = {}
    html = open(resort_url)
    
    doc = Nokogiri::HTML(html)
    
   
    resort_details = doc.css("div.pep2-at-a-glance mapModuleWrap")
    
    #doc.css("div.pep2-at-a-glance mapModuleWrap").each do |resort_details| 
    #url = resort_details.attribute("href").value
   #@@resort_details_hash
  
  end # scrape_resort_page
end #class Scraper





