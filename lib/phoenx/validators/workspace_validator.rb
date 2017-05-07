module Phoenx

	class WorkspaceValidator
		ERROR_NONE                 = 0
		ERROR_INVALID_NAME         = 1
		ERROR_INVALID_MAIN_PROJECT = 2
		
		def validate(workspace)
			if workspace.name == nil || workspace.name == ""
				return ERROR_INVALID_NAME
			end
			if workspace.main_project == nil || workspace.main_project == ""
				return ERROR_INVALID_MAIN_PROJECT			
			end
			return ERROR_NONE
		end
	
	end

end