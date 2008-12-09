class Module
	def ci_method(arg)
		arg = [arg] if arg.class != Array
		arg.each { |m|
			m = m.to_s
			self.module_eval %[
				def #{m}
					 @#{m} || @@#{m}
					# @@#{m}
				end
				def self.#{m}
					@#{m} || @@#{m}
				end
				def #{m}=(value)
					@#{m} = value
				end
				def self.#{m}=(value)
					@@#{m} = value
				end
			]
		}
	end
	def class_attr(*sym)
		#self.name.module_eval "p #{self},@@#{sym},@#{sym}"
		sym = [sym] if sym.class != Array
		sym.each {|e|
			module_eval "def self.#{e}() @@#{e} end"
			module_eval "def self.#{e}=(x) @@#{e}=x end"
		}
	end
	def non_accessor_methods
		instance_methods(nil) - accessor_methods
	end
	def accessor_methods
		(instance_methods(nil).grep(/=$/) + class_variables.map {|e| e.sub(/^@@/,'') } + 
		#sometimes need this line for erratic irb class_variables behavior
		instance_methods(nil).grep(/=$/).map {|e| e.sub(/=/,'') } +
		(instance_variables - Object.instance_variables).map {|e| e.sub(/^@/,'')} ).uniq
	end
end
