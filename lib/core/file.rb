class File
  # Converts file to string.
  def self.to_string(file)
    IO.read(file)
  end

  # Writes string to file.
  def self.string_to_file(string,file)
    File.open(file,'w') {|f| f.write(string) }
  end
end
