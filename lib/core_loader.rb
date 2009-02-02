module Core
  class Loader
    def initialize(base_class)
      @loader_base_class = base_class
      @current_library = {
        :base_class=>@loader_base_class, :base_path=>class_to_path(@loader_base_class)
      }
      @verbose = true
    end
    
    def current_base_class(force_class=true)
      if force_class
        if @current_library[:base_class].is_a?(String)
          @current_library[:base_class] = any_const_get(@current_library[:base_class])
        end
        raise "Base class needs to be a Class" if ![Class, Module].include?(@current_library[:base_class].class)
      end
      @current_library[:base_class]
    end
    
    def current_base_class_string
      current_base_class(false).to_s
    end
    
    def adds_to(klass, options = {})
      @verbose = options[:verbose] if options[:verbose]
      set_current_library(options[:library])
      extension_klass = options[:with] ? (options[:with].is_a?(String) ? class_string_to_constant(options[:with]) :
        options[:with]) : get_extension_class(klass)
      unless extension_klass
        puts "No #{current_base_class_string} extension class found"
        return false
      end
      #td: check for InstanceMethods
      instance_extension_klass = extension_klass
      include_instance_methods(klass, instance_extension_klass, options) unless options[:only] == :class
      if (options[:only] != :instance) && (class_extension_klass = get_class_extension_class(extension_klass))
        extend_class_methods(klass, class_extension_klass, options)
      end
      return true
    end
    
    def set_current_library(library)
      if library
        #td: convert string base class to real one
        @current_library = library
      end
    end

    def include_instance_methods(klass, extension_klass, options={})
      conflicts = check_instance_methods(klass, extension_klass)
      activate_extension_class(conflicts, klass, extension_klass, options) do |klass, extension_klass|
        klass.send :include, extension_klass
      end
    end

    def extend_class_methods(klass, extension_klass, options={})
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
      extension_klass = current_base_class.const_get(klass.to_s) rescue nil
      extension_klass = nil if extension_klass == klass
      extension_klass
    end
    
    def class_string_to_constant(klass)
      #adds base class if class is relative
      klass = "#{current_base_class_string}::#{klass}" if !klass.include?(current_base_class_string)
      safe_require(extension_class_to_path(klass))
      any_const_get(klass)
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
    
    def get_extension_class(klass)
      unless (extension_klass = detect_extension_class(klass))
        #try again but first by requiring possible file
        extension_class = "#{current_base_class_string}::#{klass}"
        path = extension_class_to_path(extension_class)
        safe_require(path)
        extension_klass = detect_extension_class(klass)
      end
      extension_klass
    end
    
    def safe_require(path)
      path ||= ''
      puts "loading path '#{path}'" if @verbose
      begin; require(path); rescue(LoadError); end
    end
    
    def extension_class_to_path(extension_class)
      partially_converted = extension_class.to_s.gsub(current_base_class_string, @current_library[:base_path])
      class_to_path(partially_converted)
    end
    
    def class_to_path(klass)
      #td: camelize
      klass.to_s.gsub('::','/').downcase
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
