require 'core/manager'

module Core
  module Loader
    extend self
    extend Core::Util
    attr_accessor :current_library, :verbose

    def current_base_class(force_class=true)
      if force_class
        if @current_library[:base_class].is_a?(String)
          @current_library[:base_class] = any_const_get(@current_library[:base_class])
        end
        raise "Base class needs to be a Class" if !@current_library[:base_class].is_a?(Module)
      end
      @current_library[:base_class]
    end
    
    def current_base_class_string
      current_base_class(false).to_s
    end
    
    def extends(klass, options = {})
      raise ArgumentError, "First argument should be a Module" if ! klass.is_a?(Module)
      set_current_library(options[:lib])
      @verbose = options[:verbose] if options[:verbose]
      unless (extension_klass = get_extension_base_class(klass, options[:with]))
        puts "No #{current_base_class_string} extension class found"
        return false
      end
      
      instance_extension_klass = get_instance_extension_klass(extension_klass) || extension_klass
      include_instance_methods(klass, instance_extension_klass, options) unless options[:only] == :class
      if (options[:only] != :instance) && (class_extension_klass = get_class_extension_class(extension_klass))
        extend_class_methods(klass, class_extension_klass, options)
      end
      return true
    end
    
    def set_current_library(library)
      @current_library = library ? Manager.find_or_create_library(library) : Manager.default_library
      @current_library ||= {}
    end

    def include_instance_methods(klass, extension_klass, options={})
      conflicts = check_instance_methods(klass, extension_klass)
      activate_extension_class(conflicts, klass, extension_klass, options) do |klass, extension_klass|
        klass.send :include, extension_klass
        puts "#{klass} added #{extension_klass}'s instance methods" if @verbose
      end
    end

    def extend_class_methods(klass, extension_klass, options={})
      conflicts = check_class_methods(klass, extension_klass)
      activate_extension_class(conflicts, klass, extension_klass, options) do |klass, extension_klass|
        klass.send :extend, extension_klass
        puts "#{klass} added #{extension_klass}'s class methods" if @verbose
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
    
    def get_extension_base_class(extended_klass, klass)
      if klass
        base_class = klass.is_a?(String) ? class_string_to_constant(klass) : klass
      else
        base_class = guess_extension_class(extended_klass)
      end
      base_class = nil if base_class == extended_klass
      base_class
    end
    
    def guess_extension_class(klass)
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
      path = class_to_path(partially_converted)
    end
    
    def get_instance_extension_klass(klass)
      klass.const_get("InstanceMethods") rescue nil
    end
    
    def get_class_extension_class(klass)
      klass.const_get("ClassMethods") rescue nil
    end
  end
end
