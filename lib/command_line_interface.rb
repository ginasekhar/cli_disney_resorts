require_relative "../lib/scraper.rb"
require_relative "../lib/resort.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInterface
  
  # Set path to disney vacation club page
  DVC_PATH = "https://disneyvacationclub.disney.go.com/destinations/list/"

  def run

    welcome_user
    list_resorts
    process_user_input

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
    
    puts "To see details about a particular resort, enter 'details'."
    puts "To see a list of all resorts, enter 'list'."
    puts "To quit, type 'exit'."
    puts "What would you like to do?"
    user_input = gets.strip.downcase
    
    while user_input != 'exit' do
      
      case user_input 
        when 'details'
          puts "Please enter the corresponding number of the resort:"
          user_input = gets.strip.to_i
          until user_input.is_a? Numeric
            puts "Please enter an integer number from 1 to " Resort.all.size
            user_input = gets.strip.to_i
            break if user_input.is_a? Numeric
          end
          
        when 'list'
          list_
        
        else
          puts "Invalid choice"
       end #case
    puts "What would you like to do?"
    user_input = gets.strip.downcase
    end #while
    puts "To ."
    puts "To list all of the artists in your library, enter 'list artists'."
    puts "To list all of the genres in your library, enter 'list genres'."
    puts  "To list all of the songs by a particular artist, enter 'list artist'."
    puts "To list all of the songs of a particular genre, enter 'list genre'."
    puts "To play a song, enter 'play song'."
    puts "To quit, type 'exit'."
    puts "What would you like to do?"
    user_input = gets.strip.downcase
    
    while user_input != 'exit' do
      
      case user_input 
        when 'list songs'
          list_songs
        when 'list artists'
          list_artists
        when 'list genres'
          list_genres
        when 'list artist'
          list_songs_by_artist
        when 'list genre'
          list_songs_by_genre
        when 'play song'
          play_song
        else
          puts "Invalid choice"
       end #case
    puts "What would you like to do?"
    user_input = gets.strip.downcase
    end #while
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

  def list_resorts
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
