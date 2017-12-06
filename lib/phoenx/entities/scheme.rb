module Phoenx

	class Scheme
		attr_accessor :name
		attr_accessor :archive_configuration
		attr_accessor :launch_configuration
		attr_accessor :analyze_configuration
		attr_accessor :profile_configuration
		
		def initialize(name, block)
			@name = name
			self.instance_eval(&block)
		end
	
	end

end