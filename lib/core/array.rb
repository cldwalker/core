class Array 
	#Allows you to specify ranges of elements and individual elements with one string, array starts at 1
	#example: to choose first and fourth through eighth elements: '1,4-8'
	def multislice(range,splitter=',',offset=nil)
		result = []
		for r in range.split(splitter)
		if r =~ /-/
			min,max = r.split('-')
			slice_min = min.to_i - 1
			slice_min += offset if offset
			result.push(*self.slice(slice_min, max.to_i - min.to_i + 1))
		else
			index = r.to_i - 1
			index += offset if offset
			result.push(self[index])
		end
		end
		return result
	end
	
  #Converts array of arrays to hashes
	def aoa_to_hash
    #td: consider Hash[*a1.flatten] instead
		b = {}
		each {|e| b[e[0] ] = e[1] }
		b
	end
	

	def count_hash
	  count = {}
	  each {|e|
	    count[e] ||= 0
	    count[e] += 1
	  }
	  count
	end
	
	def permute
		permutations = []
		for i in (0 .. self.size - 1)
			for j  in (i + 1 .. self.size - 1)
				permutations.push([self[i],self[j]])
			end
		end
		permutations
	end
	
	def group_aoh_by_key(key,parallel_array=nil)
		group = {}
		#keys = map {|e| e[key] }.uniq
		each_with_index {|h,i|
			#p h
			value = h[key]
			group[value] = [] if ! group.has_key?(value)
			group[value].push((parallel_array.nil?) ? h : parallel_array[i])
		}
		group
	end
	def mmap(methodname,*args)
		map {|e| e.send(methodname,*args) }
	end
	def fmap(function)
		(function =~ /\./) ?
			map {|e| eval "#{function}(e)" } :	
			map {|e| send(function,e) }
	end
	def regindex(regex)
		each_with_index {|e,i|
			return i if e =~ /#{regex}/
		}
		nil
	end
	def replace_index(i,value)
		replace( (self[0, i] || []) +  value + self[i + 1 .. -1] )
	end
	def include_and_exclude?(do_include,dont_include=[])
		include_any?(do_include) && exclude_all?(dont_include)
	end
	def include_any?(arr)
		#good for large sets w/ few matches
		#! Set.new(self).intersection(arr).empty?
		arr.any? {|e| self.include?(e) }
	end
	def exclude_all?(arr)
		! include_any?(arr)
	end
end
