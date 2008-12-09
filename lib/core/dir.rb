class Dir
	def Dir.mpwd
		Dir.pwd + "/"
	end
	def Dir.dir_children(dirname=mpwd)
		Dir.simple_entries(dirname).find_all {|e|
			File.directory?(File.join(dirname, e))
		}
	end
	def Dir.file_children(dirname=mpwd)
		Dir.simple_entries(dirname).find_all {|e|
			File.file?(File.join(dirname,e))
		}
	end
	def Dir.simple_entries(dirname=mpwd)
		dir_files = Dir.entries(dirname)
		files = dir_files - ['.','..'] - dir_files.grep(/~$/) - dir_files.grep(/\.sw[o-z]$/)
	end

	def Dir.nonlink_entries(dirname=mpwd)
		Dir.simple_entries(dirname).select {|e|
			! File.symlink?(File.join(dirname,e))
		}
	end

	def Dir.full_entries(dirname=mpwd)
		Dir.simple_entries(dirname).map {|e| File.join(dirname,e) }
	end

	def Dir.levels_of_children(dirname=mpwd,max_level=1000)
		@max_level = max_level
		@level_children = []
		Dir.get_level_children(dirname,0)
		@level_children
	end

	def Dir.get_level_children(dirname,level)
		dir_children = Dir.full_entries(dirname)
		@level_children += dir_children
		if level < @max_level
			dir_children.each {|e|
				if File.directory?(e)
					Dir.get_level_children(e,level + 1)
				end
			}
		end
	end
end
