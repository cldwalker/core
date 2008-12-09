class File
  def self.to_string(file)
    IO.read(file)
  end

  def self.string_to_file(string,file)
    File.open(file,'w') {|f| f.write(string) }
  end
  #encrypt
  #openssl des3 -salt -in infile.txt -out encryptedfile.txt
  #decrypt
  #openssl des3 -d -salt -in encryptedfile.txt -out normalfile.txt
end
