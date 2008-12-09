class Class #:nodoc:
	def real_ancestors
		ancestors - included_modules - [self]
	end
	def objects
		object = []
		#ObjectSpace.each_object(self) {|e| object.push(e.to_s) }
		ObjectSpace.each_object(self) {|e| object.push(e) }
		object
	end

	#td: used to be :objects, change tb_* files to reflect change
	def object_strings
		objects.map {|e| e.to_s}
	end
end
