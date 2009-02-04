module Core
  module Manager
    class<<self
    attr_reader :libraries
    attr_accessor :default_library
    def libraries; @libraries ||= {}; end
    def reset_libraries; @libraries = nil; end
    def reset_default_library; @default_library = nil; end

    def default_library=(lib)
      lib = find_or_create_library(lib)
      @default_library = lib if lib
    end
      
    def find_or_create_library(lib)
      if lib.is_a?(Hash)
        result_lib = create_library(lib)
      elsif lib.is_a?(Symbol)
        if libraries[lib]
          result_lib = libraries[lib]
        else
          puts "Library '#{lib}' not found"
          return nil
        end
      else
        lib_name = Core::Util.class_to_lib_name(lib)
        result_lib = libraries[lib_name] || create_library(lib)
      end
      result_lib
    end

    #td: validation
    def create_library(lib)
      library = lib.is_a?(Hash) ? lib : {:base_class=>lib, :base_path=>Core::Util.class_to_path(lib) }
      libraries[Core::Util.class_to_lib_name(library[:base_class] || library[:base_path])] = library
      library
    end
    end
  end
end
