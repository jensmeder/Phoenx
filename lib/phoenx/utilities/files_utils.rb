module Phoenx

	def Phoenx.merge_files_array(files, excluded_files = nil)
		if files == nil
			return nil
		end
		resources = []
		files.each do |source|
			resources.concat Dir[source]
		end
		unless excluded_files == nil
			resources -= merge_files_array(excluded_files)
		end
		return resources
	end

end
