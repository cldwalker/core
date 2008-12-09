class IO
def self.read_until(file,string)
	#while f.gets !~ /^#{string}/; end; p = f.pos ; f.reopen; f.read(p)
	f = IO.readlines(file)
	i = f.index(string) || 100000
	f.slice(0,i)
end
end
