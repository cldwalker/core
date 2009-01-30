$:.unshift(File.dirname(__FILE__)) unless 
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'core_loader'

module Core
  module Load
    def self.included(base)
      base.class_eval %[
        class<<self
          def adds_to(*args)
            Loader.new(#{base}).adds_to(*args)
          end
          alias_method :add_to, :adds_to
        end
      ]
    end
  end  
end
Core.send :include, Core::Load
