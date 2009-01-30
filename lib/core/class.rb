module Core
  module Class
    # Returns ancestors that aren't included modules and the class itself.
    def real_ancestors
      ancestors - included_modules - [self]
    end

    #Returns all objects of class.
    def objects
      object = []
      ObjectSpace.each_object(self) {|e| object.push(e) }
      object
    end

    #td: used to be :objects, change tb_* files to reflect change
    def object_strings #:nodoc:
      objects.map {|e| e.to_s}
    end

    def eigenclass
      instance_eval("class << self; self; end")
    end

    # gaining temporary access to private methods
    # http://blog.jayfields.com/2007/11/ruby-testing-private-methods.html
    def publicize_methods
      saved_private_instance_methods = self.private_instance_methods
      self.class_eval { public *saved_private_instance_methods }
      yield
      self.class_eval { private *saved_private_instance_methods }
    end
  end
end
