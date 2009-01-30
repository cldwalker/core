module Core
  module Symbol
    # Enable items.map(&:name) a la Rails
    def to_proc
      lambda {|*args| args.shift.__send__(self, *args)}
    end
  end 
end
