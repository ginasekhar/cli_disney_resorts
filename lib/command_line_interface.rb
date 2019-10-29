require_relative "../lib/scraper.rb"
require_relative "../lib/resort.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInterface
  
  # Set path to disney vacation club page
  DVC_PATH = "https://disneyvacationclub.disney.go.com/destinations/list/"

  def run
    welcome_user
    make_resorts
    user_menu_controller
  end #run

  def welcome_user
    puts "WELCOME TO THE DISNEY VACATION RESORT PLANNER".colorize(:orange)
    puts "**********************************************".colorize(:purple)
    puts "Your Disney villa or resort will be your Home Base for a Magical Vacation".colorize(:blue)
    puts "Our resorts and villas feature many comforts of home".colorize(:blue)
    puts "like kitchen, private bedrooms, washer and dryer".colorize(:blue)
    puts "**********************************************".colorize(:purple)
  end

  def get_validate_user_input(val_type)
    user_input = gets.strip
    if val_type == 'main_menu' && user_input.match?(/\A[:alpha:]+\z/)
      menu_option = user_input.downcase
    else
      menu_option = 'invalid'
    end

    if val_type == 'details_menu' && user_input.match?(/\A\d+\z/) && user_input.to_i.between(1,Resort.all.size)
      menu_option = user_input.to_i - 1
    else
      menu_option = nil
    end
    menu_option
  end

  def user_menu_controller
    
    puts "To see a list of all resorts, enter 'list'"
    puts "To see details about a particular resort, enter 'details'"
    puts "To see details about all resorts, enter 'all'"
    puts "To quit, type 'exit'."
    puts "What would you like to do?"
    main_menu_option = get_validate_user_input("main_menu")
    while main_menu_option != 'exit' do
      case main_menu_option
        when 'list'
          list_resorts
        when 'details'
          list_resorts
          puts "Enter the number corresponding to the resort about which you'd like information"
          puts ("Enter a number from 1 to #{Resort.all.size}")
          resort_index = get_validate_user_input("details_menu")
          while !resort_index do
            puts "Enter the number corresponding to the resort about which you'd like information"
            puts ("Enter a number from 1 to #{Resort.all.size}")
            resort_index = get_validate_user_input("details_menu")
          end #while
          populate_resort_attributes(Resort.all[resort_index])
          display_resort_details(Resort.all[resort_index])
        when 'all'
          puts "need to populate all resort attributes and display"
        else #invalid
            puts "Please enter a valid choice - (list, details or all)"
      end #case
    end
  end #user_menu_controller

  def make_resorts
    resorts_array = Scraper.scrape_destinations_page(DVC_PATH)
    Resort.create_from_collection(resorts_array)
  end

  def populate_resort_attributes(resort)
    if resort.scraped_flag == 'N'
      attributes = Scraper.scrape_resort_page(resort.url)
      resort.add_resort_attributes(attributes)
    end
  end

  def add_attributes_to_resorts
    Resort.all.each do |resort|
      attributes = Scraper.scrape_resort_page(resort.url)
      resort.add_resort_attributes(attributes)
    end
  end

  def list_resorts
    puts "Here is a list of our Magical properties: "
    puts "**********************************************".colorize(:purple)
    Resort.all.each_with_index do |resort, index|
      puts " #{index+1}. " +  "#{resort.name.upcase}".colorize(:blue)
    end
    puts "**********************************************".colorize(:purple)
  end

  def display_resort_details(resort)
      
    puts "#{resort.name.upcase}".colorize(:red)
    puts "  Website: ".colorize(:light_blue) + " #{resort.url}"
    puts "  Address: ".colorize(:light_blue) + " #{resort.street_address}"
    puts "  City: ".colorize(:light_blue) + " #{resort.address_locality}" if resort.address_locality
    puts "  State: ".colorize(:light_blue) + " #{resort.address_region}" if resort.address_region
    puts "  Phone: ".colorize(:light_blue) + " #{resort.phone}" if resort.phone
    puts "  Description: ".colorize(:light_blue) +  "#{resort.description}"
    puts "----------------------".colorize(:green)
  end


  def display_all_resort_details
    Resort.all.each {|resort| display_resort_details(resort)} 
  end

end



