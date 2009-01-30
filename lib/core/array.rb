module Core
  module Array
    # Allows you to specify ranges of elements and individual elements with one string, array starts at 1
    # Example: choose first and fourth through eighth elements: '1,4-8'
    def multislice(range,splitter=',',offset=nil)
      #td: fix swallowing of empty lines
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
  
    # Converts an even # of array elements ie [1,2,3,4]
    # or an array of array pairs ie [[1,2],[3,4]] to a hash.
    def to_hash
      Hash[*self.flatten]
    end

    # Returns hash mapping elements to the number of times they are found in the array.
    def count_hash
      count = {}
      each {|e|
        count[e] ||= 0
        count[e] += 1
      }
      count
    end
  
    # Returns all possible paired permutations of elements disregarding order.
    def permute
      permutations = []
      for i in (0 .. self.size - 1)
        for j  in (i + 1 .. self.size - 1)
          permutations.push([self[i],self[j]])
        end
      end
      permutations
    end
  
    # Assuming the array is an array of hashes, this returns a hash of the elements grouped by their
    # values for the specified hash key. 
    def group_aoh_by_key(key,parallel_array=nil)
      group = {}
      each_with_index {|h,i|
        value = h[key]
        group[value] = [] if ! group.has_key?(value)
        group[value].push((parallel_array.nil?) ? h : parallel_array[i])
      }
      group
    end

    # Maps the result of calling each element with the given method name and optional arguments.
    def mmap(methodname,*args)
      map {|e| e.send(methodname,*args) }
    end

    # Maps the result of calling the given function name with each element as its argument.
    def fmap(function)
      (function =~ /\./) ?
        map {|e| eval "#{function}(e)" } :  
        map {|e| send(function,e) }
    end

    # Returns index of first element to match given regular expression.
    def regindex(regex)
      each_with_index {|e,i|
        return i if e =~ /#{regex}/
      }
      nil
    end

    # Replaces element at index with values of given array.
    def replace_index(i,array)
      replace( (self[0, i] || []) +  array + self[i + 1 .. -1] )
    end

    # Returns true if the array includes any from the first array and excludes all from the second.
    def include_and_exclude?(do_include,dont_include=[])
      include_any?(do_include) && exclude_all?(dont_include)
    end

    # Returns true if it has any elements in common with the given array.
    def include_any?(arr)
      #good for large sets w/ few matches
      #! Set.new(self).intersection(arr).empty?
      arr.any? {|e| self.include?(e) }
    end


    # Returns true if it has no elements in common with the given array.
    def exclude_all?(arr)
      ! include_any?(arr)
    end

    # A real array def, not a set diff
    # a1 = [1,1,2]
    # a2 = [1,2]
    # a1 - a2 #=> []
    # a1.diff(a2) #=> [1]
    def diff(other)
      list = self.dup
      other.each { |elem| list.delete_at( list.index(elem) ) }
      list
    end
  end
end
