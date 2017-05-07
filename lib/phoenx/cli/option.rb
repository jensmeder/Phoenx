module Phoenx

	module Cli

		class Option
	
			attr_accessor :name
			attr_accessor :short_cut
			attr_accessor :description
			attr_accessor :has_argument
		
			@block
		
			def initialize(name, short_cut, description, has_argument, &block)
				@name = name
				@short_cut = short_cut
				@description = description
				@has_argument = has_argument
				@block = block	
			end
		
			def execute
				@block.call
			end
	
		end
	
	end
	
end