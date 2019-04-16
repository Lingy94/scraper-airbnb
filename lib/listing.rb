#Created class to store the scraped data that instantiates with a hash
class Listing
    attr_accessor :hash

    @@all = []

    def initialize
        self.hash = {}
        @@all << self
    end

    def self.all
        @@all
    end

end