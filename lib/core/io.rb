class IO
  #Returns array of lines up until the given string matches a line of the file.
  def self.read_until(file,string)
    f = self.readlines(file)
    i = f.index(string) || 100000
    f.slice(0,i)
  end
  
  #from output_catcher gem
  def self.capture_stdout(&block)
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
