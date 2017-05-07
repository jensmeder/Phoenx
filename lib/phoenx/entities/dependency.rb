module Phoenx

	class Dependency
		attr_accessor :target_name
		attr_accessor :path
		attr_accessor :embed
	
		def initialize(target_name, embed = true, path = nil)
			@target_name = target_name
			@path = path
			@embed = embed
		end
	
	end

end