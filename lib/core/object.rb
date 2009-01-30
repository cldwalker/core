module Core
  module Object
    
    module ClassMethods
      # A more versatile version of Object.const_get.
      # Retrieves constant for given string, even if it's nested under classes.
      def any_const_get(name)
        begin
        klass = Object
        name.split('::').each {|e|
          klass = klass.const_get(e)
        }
        klass
        rescue; nil; end
      end
    end

    #Reloads a file just as you would require it.
    def reload(filename)
      $".delete(filename + ".rb")
      require(filename)
    end

    # list methods which aren't in superclass
    def local_methods(obj = self)
      (obj.methods - obj.class.superclass.instance_methods).sort
    end

    def backtick(cmd,*args)
      IO.popen('-') {|f| f ? f.read : exec(cmd,*args)}
    end
  end
end
