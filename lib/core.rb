$:.unshift(File.dirname(__FILE__)) unless 
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
module Core
  module Loader    
    def self.included(base)
      base.extend(self)
    end
    
    def adds_to(klass, options = {})
      unless (extension_klass = options[:with] || get_extension_class(klass))
        puts "No #{self} extension class found"
        return false
      end
      conflicts = check_for_conflicts(klass, extension_klass)
      if conflicts.empty? || options[:force]
        klass.send :include, extension_klass
      else
        puts "Couldn't include #{extension_klass} into #{klass} because the following methods conflict:"
        puts conflicts.sort.join(", ")
        false
      end
    end
    alias_method :add_to, :adds_to
    
    def detect_extension_class(klass)
      extension_klass = self.const_get(klass.to_s) rescue nil
      extension_klass = nil if extension_klass == klass
      extension_klass
    end
    
    def get_extension_class(klass)
      unless (extension_klass = detect_extension_class(klass))
        #try again but first by requiring possible file
        begin; require("#{self.to_s.gsub('::','/').downcase}/#{klass.to_s.downcase}"); rescue(LoadError); end
        extension_klass = detect_extension_class(klass)
      end
      extension_klass
    end
  
    def check_for_conflicts(klass, extension_klass)
      if false #TODO: extension_klass.to_s =~ /ClassMethods/
      else
        all_instance_methods(klass) & all_instance_methods(extension_klass)
      end
    end
  
    def all_instance_methods(klass)
      klass.public_instance_methods + klass.private_instance_methods + klass.protected_instance_methods
    end
  end
end

Core.send :include, Core::Loader

__END__

#extend Array with Core::Array's ClassMethods + InstanceMethods
Core.adds_to Array

#extend MyArray from file
class My::Array
  Core.adds_to self
end

#from console
Core.adds_to My::Array

#extend Array only with ClassMethods
Core.adds_to Array, :from=>Core::Array::ClassMethods
