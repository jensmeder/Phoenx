module Phoenx

	def Phoenx.merge_files_array(files)
	
		if files == nil
		
			return nil
		
		end
		
		resources = []
		files.each do |source|
			
			resources.concat Dir[source]
			
		end
		
		return resources
	
	end

end