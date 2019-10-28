class Resort

  attr_accessor :name, :resort_url, :resort_street, :resort_locality, :resort_region 

  @@all = []

  def initialize(resort_hash)
    resort_hash.each {|key, value| self.send(("#{key}="), value)}
    @@all << self
  end

  def self.create_from_collection(resorts_array)
    resorts_array.each { |resort_hash| self.new(resort_hash) }
  end

  def add_resort_attributes(attributes_hash)

    attributes_hash.each {|key, value| self.send(("#{key}="), value)}
  end

  def self.all
    @@all
  end
end
