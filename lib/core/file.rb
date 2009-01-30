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
      
      #mac only: http://stream.btucker.org/post/65635235/file-creation-date-in-ruby-on-macs
      def creation_time(file)
        require 'open3'
        require 'time'
         Time.parse( Open3.popen3("mdls", 
          "-name","kMDItemContentCreationDate", 
          "-raw", file)[1].read)
      end
      
    end
  end
end
