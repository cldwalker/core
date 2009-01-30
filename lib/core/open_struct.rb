require 'ostruct'

# Explained http://tagaholic.blogspot.com/2009/01/simple-block-to-hash-conversion-for.html
module Core
  module OpenStruct
    module ClassMethods
      def block_to_hash(block=nil)
        config = self.new
        if block
          block.call(config)
          config.to_hash
        else
          {}
        end
      end
    end

    def to_hash
      @table
    end
  end
end
