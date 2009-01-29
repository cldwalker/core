module Core
  module File
    module ClassMethods
      # Converts file to string.
      def to_string(file)
        IO.read(file)
      end

      # Writes string to file.
      def string_to_file(string,file)
        File.open(file,'w') {|f| f.write(string) }
      end
    end
  end
end
