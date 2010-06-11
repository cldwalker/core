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
      libraries[library_name(library)] = library
      library
    end

    def library_name(library)
      Core::Util.class_to_lib_name(library[:base_class] || library[:base_path])
    end

    def list_files(options={})
      lib = options[:lib] || library_name(default_library)
      current_lib = libraries[lib]
      path = `gem which -q #{lib}`.chomp
      if path && !path.empty?
        base_dir = File.join(File.dirname(path), current_lib[:base_path])
        class_dir = options[:class] ? File.join(base_dir, options[:class]) : base_dir
        Dir["#{class_dir}/**/*.rb"].map {|e| e.gsub(base_dir + "/", '') }
      else
        puts "No path found for '#{lib}'"
      end
    end
    end
  end
end
