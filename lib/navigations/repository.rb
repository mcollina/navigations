require File.dirname(__FILE__) + "/navigator"

module Navigations
  class Repository

    @@instances = Hash.new do |hash, name|
      navigator = Navigator.new(name)
      hash[navigator.name]= navigator
      navigator
    end

    def self.instances
      @@instances.values
    end

    def self.get(name,&block)
      navigator = @@instances[name.to_sym]
      yield navigator if(block != nil)
      navigator
    end
  
  end
end
