require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  @@resorts_array = []
  
  def self.scrape_destinations_page(destinations_url)
    
    html = open(destinations_url)
    doc = Nokogiri::HTML(html)
    doc.css(".dvcss-dt-cell.media-body-center").each do |each_resort|
      resort_summary = {}
      resort_summary[:name] = each_resort.css("a.dvcss-listing-item-card-description.clickable").attribute("aria-label").value
      resort_summary[:url] = each_resort.css("a.dvcss-listing-item-card-description.clickable").attribute("href").value
      @@resorts_array << resort_summary
    end #each
    
    @@resorts_array
  end #scrape_destinations_page

  def self.scrape_resort_page(resort_url)
    @@resort_details_hash = {}
    html = open(resort_url)
    
    doc = Nokogiri::HTML(html)
    
    resort_address =   doc.css("div.pep2-at-a-glance.mapModuleWrap")
    if resort_address.at("//span[@itemprop = 'streetAddress']") 
      @@resort_details_hash[:street_address] = resort_address.at("//span[@itemprop = 'streetAddress']").children.text
    elsif resort_address[0]
      @@resort_details_hash[:street_address] = resort_address[0].inner_text
    elsif doc.css("div#atGlanceModule > div.moduleDescription")
      @@resort_details_hash[:street_address] = doc.css("div#atGlanceModule > div.moduleDescription")[0].inner_text
    end
      
    if resort_address.at("//span[@itemprop = 'addressLocality']")
      @@resort_details_hash[:address_locality] =resort_address.at("//span[@itemprop = 'addressLocality']").children.text 
    # else 
    #   @@resort_details_hash[:address_locality] = 'Not Available'
    end
    
    if resort_address.at("//span[@itemprop = 'addressRegion']")
      @@resort_details_hash[:address_region] = resort_address.at("//span[@itemprop = 'addressRegion']").children.text 
    # else
    #   (@@resort_details_hash[:address_region] = 'Not Available')
    end
    
    if resort_address.css("p.visible-xs").css("a").attribute("href")
      @@resort_details_hash[:phone] = resort_address.css("p.visible-xs").css("a").attribute("href").text 
    # else 
    #   @@resort_details_hash[:phone] = 'Not Available'
    end
    #binding.pry
    if doc.css("div.mainDescription")
      @@resort_details_hash[:description] = doc.css("div.mainDescription")[0].inner_text 
    else 
      @@resort_details_hash[:description] = 'Not Available'
    end
  
   @@resort_details_hash
  
  end # scrape_resort_page
end #class Scraper
