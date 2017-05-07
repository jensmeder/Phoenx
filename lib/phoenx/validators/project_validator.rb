module Phoenx
	
	class ProjectValidator
		ERROR_NONE         = 0
		ERROR_INVALID_NAME = 1
		
		def validate(project)
			if project.name == nil || project.name == ""
				return ERROR_INVALID_NAME
			end
			return ERROR_NONE
		end
		
	end

end
