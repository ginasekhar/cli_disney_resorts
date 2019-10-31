class Resort

  attr_accessor :name, :url, :street_address, :address_locality, :address_region, :phone, :description, :scraped_flag

  @@all = []


  def initialize(resort_hash)
    #for each attribute, set the value
    resort_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(resorts_array)
    #for each resort hash in the array, create a new resort object
    resorts_array.each { |resort_hash| self.new(resort_hash) }
  end

  def add_resort_attributes(attributes_hash)
    #update the resort object with the key/attribute pairs passed in
    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    #return the class variable @@all containing all instances of this class
    @@all
  end
end
