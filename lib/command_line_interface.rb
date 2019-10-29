require_relative "../lib/scraper.rb"
require_relative "../lib/resort.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInterface
  
  # Set path to disney vacation club page
  DVC_PATH = "https://disneyvacationclub.disney.go.com/destinations/list/"

  def run

    welcome_user
    display_resorts
    
    
    
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

  def welcome_user
    puts "WELCOME TO THE DISNEY VACATION RESORT PLANNER".colorize(:orange)
    puts "**********************************************".colorize(:purple)
    puts "Your Disney villa or resort will be your Home Base for a Magical Vacation".colorize(:blue)
    puts "Our resorts and villas feature many comforts of home".colorize(:blue)
    puts "like kitchen, private bedrooms, washer and dryer".colorize(:blue)
    puts "**********************************************".colorize(:purple)
  end
  
  def process_user_input
    
    puts "Please enter Y to continue or N to quit" 
    user_input = gets.strip.upcase
    while user_input != 'exit' do

      case user_input 
        when 'list'
          list_resorts
        when 'list resort_details'
          list_resort_details
        else
          puts "Invalid choice"
        end #case
    puts "What would you like to do?"
    user_input = gets.strip.downcase
    end #while
  end
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
    puts "Here is a list of our Magical properties: "
    puts "**********************************************".colorize(:purple)
    Resort.all.each_with_index do |resort, index|
      puts " #{index+1}. " +  "#{resort.name.upcase}".colorize(:blue)
    end
    puts "**********************************************".colorize(:purple)
  end
  
  def display_resort_details(resort_num)
    
    resort = Resort.all[resort_num]
      
      puts "#{resort.name.upcase}".colorize(:red)
      puts "  Website: ".colorize(:light_blue) + " #{resort.url}"
      puts "  Address: ".colorize(:light_blue) + " #{resort.street_address}"
      puts "  City: ".colorize(:light_blue) + " #{resort.address_locality}" if resort.address_locality
      puts "  State: ".colorize(:light_blue) + " #{resort.address_region}" if resort.address_region
      puts "  Phone: ".colorize(:light_blue) + " #{resort.phone}" if resort.phone
      puts "  Description: ".colorize(:light_blue) +  "#{resort.description}"
      puts "----------------------".colorize(:green)
    end
  end

end
