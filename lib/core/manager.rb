module Core
  module Manager
    class<<self
    attr_reader :libraries
    attr_accessor :default_library
    def libraries; @libraries ||= {}; end
    def reset_libraries; @libraries = nil; end

    def default_library=(lib_or_class)
      if lib_or_class.is_a?(Hash)
        @default_library = create_library(lib_or_class)
      else
        lib_name = lib_or_class.is_a?(Symbol) ? lib_or_class : Core::Util.class_to_lib_name(lib_or_class)
        @default_library = libraries[lib_name] || create_library(lib_or_class)
      end
      @default_library
    end

    #td: validation
    def create_library(lib)
      library = lib.is_a?(Hash) ? lib : {:base_class=>lib, :base_path=>Core::Util.class_to_path(lib) }
      libraries[Core::Util.class_to_lib_name(library[:base_class])] = library
      library
    end
    end
  end
end
