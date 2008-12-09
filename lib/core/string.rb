class String
	def count_any(str)
		count = 0
		self.gsub(str) {|s| 
			count += 1
			str
		}
		count
	end
end
