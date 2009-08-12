
module Navigations
  module Navigable
    def self.included(klass)
      super
      klass.class_inheritable_reader :navigator
      klass.write_inheritable_attribute(:navigator, Navigator.new)
    end
  end
end
