module Core
  module Util
    extend self
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

    def any_const_get(name)
      begin
        klass = Object
        name.split('::').each {|e|
          klass = klass.const_get(e)
        }
        klass
      rescue
         nil
      end
    end

    #From Rails ActiveSupport
    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
       gsub(/([a-z\d])([A-Z])/,'\1_\2').
       tr("-", "_").
       downcase
    end
  end
end
