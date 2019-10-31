

class CommandLineInterface
  
  # Set path to disney vacation club page
  DVC_PATH = "https://disneyvacationclub.disney.go.com/destinations/list/"

  def run
    # Create the array of resorts objects with name and url
    make_resorts

    #Display user welcome message
    welcome_user

    #Show user the list of all resorts
    list_resorts

    #Call controller to interact with user
    user_menu_controller
  end #run

  def welcome_user
    puts "WELCOME TO THE DISNEY VACATION RESORT PLANNER".colorize(:blue)
    puts "****************************************************************************".colorize(:blue)
    puts "Your Disney villa or resort will be your Home Base for a Magical Vacation".colorize(:light_blue)
    puts "Our resorts and villas feature many comforts of home".colorize(:light_blue)
    puts "like kitchens, private bedrooms, washer and dryer".colorize(:light_blue)
    puts "****************************************************************************".colorize(:blue)
  
  end

  def get_validate_user_input
    #get user input
    user_input = gets.strip
    
    #User input can either be a keyword or a number
    # If user input is alphabetic, verify it is one of the allowed keywords (list,exit), format & return it
    if user_input.match(/\A[A-Za-z]+\z/) && ((user_input.downcase == "exit") || (user_input.downcase == "list"))
      return(user_input.downcase)
      #if user input is all digits, check that it is between 1 and total number of resorts, return index
    elsif user_input.match(/\A\d+\z/) && user_input.to_i.between?(1,Resort.all.size)
      return (user_input.to_i - 1)
    else 
      return nil
    end
  end

  def user_menu_controller
    
    #Prompt user for input
    puts "To see details about a particular resort, enter the number corresponding to the resort".colorize(:green)
    puts ("Enter a number from 1 to #{Resort.all.size}").colorize(:green)
    puts "To quit, type 'exit'.".colorize(:green)
  
    #get and validate input
    main_menu_option = get_validate_user_input
    
    # Keep looping until user enters exit
    while main_menu_option != "exit" do
      #if user entered invalid option
      if !main_menu_option
        puts "That is not a valid choice".colorize(:red)
      elsif main_menu_option == 'list'
        list_resorts
      else #this should be a number
        #first populate attributes for individual resort page, then display on screen
        populate_resort_attributes(Resort.all[main_menu_option])
        display_resort_details(Resort.all[main_menu_option])
      end
      #Prompt user again for input
      puts "Enter 'list' to see the list of resorts, 'exit' to quit OR".colorize(:green)
      puts "Enter a number from 1 to #{Resort.all.size} corresponding to the resort about which you'd like information".colorize(:green)
      puts "What would you like to do next? (exit, list) OR enter a number".colorize(:green)
      main_menu_option = get_validate_user_input
    end #while 
  end #user_menu_controller

  def make_resorts
    #Scrape main Disney Vacation Club destination page and create array of resort objects
    resorts_array = Scraper.scrape_destinations_page(DVC_PATH)
    Resort.create_from_collection(resorts_array)
  end

  def populate_resort_attributes(resort)
    #if we haven't grabbed the attributes yet, scrape resort page for them and populate resort object 
    if resort.scraped_flag == 'N'
      attributes = Scraper.scrape_resort_page(resort.url)
      resort.add_resort_attributes(attributes)
    end
  end

  #This method is not being used.  It can be used if you want to scrape every resort page in the resorts array
  def add_attributes_to_resorts
    Resort.all.each do |resort|
      attributes = Scraper.scrape_resort_page(resort.url)
      resort.add_resort_attributes(attributes)
    end
  end

  #Iterate through resorts array and type position and name
  def list_resorts
    puts "HERE IS A LIST OF OUR MAGICAL PROPERTIES: ".colorize(:red)
    puts "*************************************************************".colorize(:blue)
    Resort.all.each_with_index do |resort, index|
      puts " #{index+1}. " +  "#{resort.name.upcase}".colorize(:blue)
    end
    puts "*************************************************************".colorize(:blue)
  end

  def display_resort_details(resort)
    puts "_______________________________________________________________________________________________".colorize(:green)
    puts "#{resort.name.upcase}".colorize(:red)
    puts "  Website: ".colorize(:light_blue) + " #{resort.url}"
    puts "  Address: ".colorize(:light_blue) + " #{resort.street_address}"
    puts "  City: ".colorize(:light_blue) + " #{resort.address_locality}" if resort.address_locality
    puts "  State: ".colorize(:light_blue) + " #{resort.address_region}" if resort.address_region
    puts "  Phone: ".colorize(:light_blue) + " #{resort.phone}" if resort.phone
    puts "  Description: ".colorize(:light_blue) +  "\n\t#{resort.description}"
    puts "_______________________________________________________________________________________________".colorize(:green)
  end

end



