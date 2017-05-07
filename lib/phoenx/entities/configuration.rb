module Phoenx

	class Configuration
		attr_accessor :parent
		attr_accessor :name
		
		def initialize(name, parent)
			@name = name
			@parent = parent
		end
	
	end

end