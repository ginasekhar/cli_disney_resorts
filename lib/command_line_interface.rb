require_relative "../lib/scraper.rb"
require_relative "../lib/resort.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInterface
  
  # Set path to disney vacation club page
  DVC_PATH = "https://disneyvacationclub.disney.go.com/destinations/list/"

  def run
    
    # Welcome user and prompt for response 
    puts "Ready to plan your next Disney vacation?"
    puts "I can show you a multitude of wonderful Disney properties"
    puts "Your Disney villa or resort will be your Home Base for a Magical Vacation"
    puts "Our resorts and villas feature many comforts of home"
    puts "like kitchen, private bedrooms, washer and dryer"
    puts "Would you like to learn more about our vacation homes?"
    puts "Please enter Y to continue or N to quit" 
    user_input = gets.strip.upcase
    
    #Validate that user entered something, input is alphabetical, and that it is either Y or N, otherwise loop till it is
    #while user_input.empty? || !user_input.match(/\A[a-zA-Z]*\z/).nil? user_input.upcase != 'Y' || user_input.upcase != 'N'
    while user_input.empty?
      puts "Please enter a valid response (Y or N)"
      user_input = gets.strip.upcase
    end #while
    
    # If user enter N (or n), display goodbye msg and exit 
    if user_input == 'N'
      puts "Please come back when you are ready to plan your Disney vacation.  Goodbye!"
    elsif user_input == 'Y'  # if user entered Y
      
      puts "User said Y"
      make_resorts
      add_attributes_to_resorts
      display_resorts
    end #if 

  end #run

  def make_resorts
    puts "running make_resorts"
    resorts_array = Scraper.scrape_destinations_page(DVC_PATH)
    Resort.create_from_collection(resorts_array)
  end

  def add_attributes_to_resorts
    puts "running add_attributes_to_resorts"
    Resort.all.each do |resort|
      attributes = Scraper.scrape_resort_page(resort.url)
      resort.add_resort_attributes(attributes)
    end
  end

  def display_resorts
    puts "display_resorts"
    Resort.all.each do |resort|
      :name, :url, :street_address, :address_locality, :address_region, :phone
      puts "#{resort.name.upcase}".colorize(:blue)
      puts "  Website:".colorize(:light_blue) + " #{resort.url}"
      puts "  Street:".colorize(:light_blue) + " #{resort.street_address}"
      puts "  City:".colorize(:light_blue) + " #{resort.address_locality}"
      puts "  State:".colorize(:light_blue) + " #{resort.address_region}"
      puts "  Phone".colorize(:light_blue) + " #{resort.phone}"
      puts "----------------------".colorize(:green)
    end
  end

end
