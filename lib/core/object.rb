class Object
  # A more versatile for of Object.const_get.
  # Retrieves constant for given string, even if it's nested under classes.
  def self.any_const_get(name)
    begin
    klass = Object
    name.split('::').each {|e|
      klass = klass.const_get(e)
    }
    klass
    rescue; nil; end
  end

  #Reloads a file just as you would require it.
  def reload(filename)
    $".delete(filename + ".rb")
    require(filename)
  end
end
