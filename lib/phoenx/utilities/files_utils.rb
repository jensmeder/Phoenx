module Phoenx

	def Phoenx.merge_files_array(files)
	
		resources = []
		files.each do |source|
			
			resources.concat Dir[source]
			
		end
		
		return resources
	
	end

end