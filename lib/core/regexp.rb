module Core
  module Regexp
    # Convenience method on Regexp so you can do
    # /an/.show_match("banana")
    # stolen from the pickaxe
    def show_regexp(a, re)
       if a =~ re
          "#{$`}<<#{$&}>>#{$'}"
       else
          "no match"
       end
    end
    def show_match(a)
      show_regexp(a, self)
    end
  end
end
