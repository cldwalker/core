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
  end
end
