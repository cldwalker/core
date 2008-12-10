class IO
  #Returns array of lines up until the given string matches a line of the file.
  def self.read_until(file,string)
    f = self.readlines(file)
    i = f.index(string) || 100000
    f.slice(0,i)
  end
end
