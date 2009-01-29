module Core
  module Hash
    # For a hash whose keys are strings of Class names, this will delete any pairs that have
    # nonexistant class names.
    def validate_value_klass(klass)
      self.each {|sid,obj|
        if obj.class != Object.const_get(klass)
          warn "object of '#{sid}' not a #{klass}"
          self.delete(sid)
        end
      }
    end  

    # Returns a hash which will set its values by calling each value with the given method and optional argument.
    # If a block is passed, each value will be set the value returned by its block call.
    def vmap(arg=nil,method='[]',&block)
      new = {}
      if block
        self.each {|k,v|
          v1 = yield(k,v)
          new[k] = v1
        }
      else  
        self.each {|k,v|
          new[k] = arg.nil? ? v.send(method) : v.send(method,arg)
        }
      end
      new
    end
    
    # Same as vmap() but merges its results with the existing hash.
    def vmap!(*args,&block)
      self.update(vmap(*args,&block))
    end

    # For a hash whose values are arrays, this will return a hash with each value substituted by the
    # size of the value.
    def vsize
      vmap(nil,'size')
    end

    # Same as pass_keys!() but replaces the hash with the resulting hash.
    def only_keep(arr=[],opt={})
      delete_keys!(self.keys - arr,opt)
    end

    def delete_keys!(arr=[],opt={}) #:nodoc:
      deleted = {}
      arr.each {|e| 
        puts "deleting #{e}" if opt[:verbose]
        deleted[e] = self.delete(e) if has_key?(e)
      }
      deleted
    end
    
    # Returns a subset of the hash for the specified keys. These entries will be deleted from the
    # original hash.
    def pass_keys!(*keys)
      delete_keys!(keys)
    end

    # For a hash whose values are arrays, this will set each unique element in a value array as a key
    # and set its values to all the keys it occurred in.
    # This is useful when modeling one to many relationships with keys
    # and values.
    def transform_many
      b = {}
      each {|k,arr| 
        #raise "#{arr.inspect} not an Array" if arr.class != Array
        arr = [arr] if arr.class != Array
        arr.each {|e| 
          b.has_key?(e) ? b[e].push(k) : b[e] = [k]
        }
      }
      b
    end

    #Sorts hash by values, returning them as an array of array pairs.
    def vsort
      sort { |a,b| b[1]<=>a[1] }
    end
  end
end
