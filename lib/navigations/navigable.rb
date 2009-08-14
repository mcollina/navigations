
module Navigations
  module Navigable
    def self.included(klass)
      super
      klass.class_inheritable_reader :navigator
      klass.write_inheritable_attribute(:navigator, Navigator.new)
      klass.send(:extend, ClassMethods)
    end

    module ClassMethods
      def check name, code=nil
        name = name.to_s.underscore
        code ||= "true"
        
        class_eval <<-EOF
          def #{name}?
            var = instance_variable_get(:@#{name})
            return false unless var
            #{code}
          end
EOF
        self
      end

      def check_model name
        check name, "not var.nil? and not var.new_record?"
      end
    end
  end
end
