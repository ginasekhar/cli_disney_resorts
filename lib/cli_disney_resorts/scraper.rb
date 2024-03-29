

class Scraper

  @@resorts_array = []
  
  def self.scrape_destinations_page(destinations_url)
    

    html = open(destinations_url)
    doc = Nokogiri::HTML(html)

    # Iterate through all resorts and get it's name and url. Initialize scraped_flag. 
    doc.css(".dvcss-dt-cell.media-body-center").each do |each_resort|
      resort_summary = {}  #Initialize summary hash
      resort_summary[:name] = each_resort.css("a.dvcss-listing-item-card-description.clickable").attribute("aria-label").value
      resort_summary[:url] = each_resort.css("a.dvcss-listing-item-card-description.clickable").attribute("href").value
      resort_summary[:scraped_flag] = 'N'
      @@resorts_array << resort_summary
    end #each
    #return array containing hash of scraped data
    @@resorts_array
  end #scrape_destinations_page

  def self.scrape_resort_page(resort_url)
    @@resort_details_hash = {}
    html = open(resort_url)
    
    doc = Nokogiri::HTML(html)
    
    resort_address =   doc.css("div.pep2-at-a-glance.mapModuleWrap")
    
    #Due to inconsistencies in each resort page, need to extract address multiple ways on different pages
    if resort_address.at("//span[@itemprop = 'streetAddress']") 
      @@resort_details_hash[:street_address] = resort_address.at("//span[@itemprop = 'streetAddress']").children.text.strip
    elsif resort_address.css("p")[0] #this only applies to hilton head
      split_addr = resort_address.css("p")[0].children.text.strip.split("\n")
      @@resort_details_hash[:street_address] = split_addr[0]
      @@resort_details_hash[:address_locality] = split_addr[1].split(",")[0]
      @@resort_details_hash[:address_region] = split_addr[1].split(",")[1]
    elsif resort_address.children[2] #this only applies to riviera
      @@resort_details_hash[:street_address] = resort_address.children[2].text.strip
      split_addr = resort_address.children[4].text.strip.split(',') # this is for riviera 
      @@resort_details_hash[:address_locality] = split_addr[0]
      @@resort_details_hash[:address_region] = split_addr[1]
    elsif doc.css("div#atGlanceModule > div.moduleDescription")
      @@resort_details_hash[:street_address] = doc.css("div#atGlanceModule > div.moduleDescription").text.strip
    end #if
      
    if resort_address.at("//span[@itemprop = 'addressLocality']")
      @@resort_details_hash[:address_locality] =resort_address.at("//span[@itemprop = 'addressLocality']").children.text.strip
    end #if
    
    if resort_address.at("//span[@itemprop = 'addressRegion']")
      @@resort_details_hash[:address_region] = resort_address.at("//span[@itemprop = 'addressRegion']").children.text.strip 
    end #if
    
    if resort_address.css("p.visible-xs").css("a").attribute("href")
      @@resort_details_hash[:phone] = resort_address.css("p.visible-xs").css("a").attribute("href").text.strip
    elsif resort_address.css("p")[1] #this only applies to hilton head
      @@resort_details_hash[:phone] = resort_address.css("p")[1].children.text.strip
    end #if
    
    if doc.css("div.mainDescription > p")[0]
      @@resort_details_hash[:description] = doc.css("div.mainDescription > p").text.strip
    
    else
      @@resort_details_hash[:description] = doc.css("div.mainDescription").text.strip
    
    end #if

    @@resort_details_hash[:scraped_flag] = 'Y'
  
   @@resort_details_hash
  
  end # scrape_resort_page
end #class Scraper
