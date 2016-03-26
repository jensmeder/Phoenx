module Phoenx

	class ConfigurationValidator
	
		ERROR_NONE         = 0
		ERROR_INVALID_NAME = 1
		
		def validate(configuration)
		
			if configuration.name == nil || configuration.name == ""
			
				return ERROR_INVALID_NAME
			
			end
			
			return ERROR_NONE
		
		end
	
	end

end