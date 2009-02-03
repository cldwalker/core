module Core
  module Manager
    class<<self
    attr_reader :libraries
    attr_accessor :default_library
    def libraries; @libraries ||= {}; end

    def default_library=(lib_or_class)
      lib_name = lib_or_class.is_a?(Symbol) ? lib_or_class : Core::Util.class_to_lib_name(lib_or_class)
      @default_library = libraries[lib_name] || create_library(lib_or_class)
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
