module Core
  module IO
    module ClassMethods
      #Returns array of lines up until the given string matches a line of the file.
      def read_until(file,string)
        f = readlines(file)
        i = f.index(string) || 100000
        f.slice(0,i)
      end
      
      #from output_catcher gem
      def capture_stdout(&block)
        original_stdout = $stdout
        $stdout = fake = StringIO.new
        begin
          yield
        ensure
          $stdout = original_stdout
        end
        fake.string
      end
    end
  end
end
