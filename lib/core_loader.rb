module Core
  module Loader    
    def self.included(base)
      base.extend(self)
    end
    
    def adds_to(klass, options = {})
      unless (extension_klass = options[:with] || get_extension_class(klass))
        puts "No #{self} extension class found"
        return
      end
      instance_extension_klass = extension_klass
      include_instance_methods(klass, instance_extension_klass, options) unless options[:only] == :class
      if (options[:only] != :instance) && (class_extension_klass = get_class_extension_class(extension_klass))
        extend_class_methods(klass, class_extension_klass, options)
      end
    end
    alias_method :add_to, :adds_to

    def include_instance_methods(klass, extension_klass, options)
      conflicts = check_instance_methods(klass, extension_klass)
      activate_extension_class(conflicts, klass, extension_klass, options) do |klass, extension_klass|
        klass.send :include, extension_klass
      end
    end

    def extend_class_methods(klass, extension_klass, options)
      conflicts = check_class_methods(klass, extension_klass)
      activate_extension_class(conflicts, klass, extension_klass, options) do |klass, extension_klass|
        klass.send :extend, extension_klass
      end
    end

    def activate_extension_class(conflicts, klass, extension_klass, options)
      if conflicts.empty? || options[:force]
        yield(klass, extension_klass)
      else
        puts "Couldn't include #{extension_klass} into #{klass} because the following methods conflict:"
        puts conflicts.sort.join(", ")
      end
    end
    
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

    def get_class_extension_class(klass)
      klass.const_get("ClassMethods") rescue nil
    end

    def check_class_methods(klass, extension_klass)
      all_class_methods(klass) & all_instance_methods(extension_klass)
    end

    def check_instance_methods(klass, extension_klass)
      all_instance_methods(klass) & all_instance_methods(extension_klass)
    end

    def all_class_methods(klass)
      klass.public_methods + klass.private_methods + klass.protected_methods
    end

    def all_instance_methods(klass)
      klass.public_instance_methods + klass.private_instance_methods + klass.protected_instance_methods
    end
  end
end
