class Hash #:nodoc:
  #validate_value_klass!
  def validate_value_klass(klass)
    self.each {|sid,obj|
      if obj.class != Object.const_get(klass)
        warn "object of '#{sid}' not a #{klass}"
        self.delete(sid)
      end
    }
  end  
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
  def vmap!(*args,&block)
    self.update(vmap(*args,&block))
  end
  def vsize
    vmap(nil,'size')
  end
  #only_keep!
  def only_keep(arr=[],opt={})
    delete_keys!(self.keys - arr,opt)
  end
  #alias_method :keep_keys
  def delete_keys!(arr=[],opt={})
    deleted = {}
    arr.each {|e| 
      puts "deleting #{e}" if opt[:verbose]
      deleted[e] = self.delete(e) if has_key?(e)
    }
    deleted
  end
  def pass_keys!(*keys)
    delete_keys!(keys)
  end
  #alias_method: hash_subset
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
  def vsort
    sort { |a,b| b[1]<=>a[1] }
  end
end
