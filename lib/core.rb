module Core
  VERSION = "0.1.0"
  extend self
  
  def adds_to(klass, options = {})
    extension_klass = options[:from]
    require("core/#{klass.to_s.downcase}") if extension_klass.nil?
    extension_klass ||=  Core.const_get(klass.to_s) rescue nil
    puts("No Core class found") and return nil unless extension_klass
    
    conflicts = check_for_conflicts(klass, extension_klass)
    if conflicts.empty? || options[:force]
      klass.send :include, extension_klass
    else
      puts "Couldn't include #{extension_klass} into #{klass} because the following methods conflict:"
      puts conflicts.sort.join(", ")
    end
  end
  
  def check_for_conflicts(klass, extension_klass)
    if extension_klass.to_s =~ /ClassMethods/
      puts "TODO"
    else
      all_instance_methods(klass) & all_instance_methods(extension_klass)
    end
  end
  
  def all_instance_methods(klass)
    klass.public_instance_methods + klass.private_instance_methods + klass.protected_instance_methods
  end
end

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
