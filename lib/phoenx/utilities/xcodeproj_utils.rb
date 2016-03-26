require 'xcodeproj'

module Phoenx

	def Phoenx.is_bundle?(file)
		
		return file.include?('xcassets') || file.include?('bundle')
		
	end

	def Phoenx.add_groups_for_files(project,files)
	
		files.each do |path|
			
			groups = File.dirname(path).split("/")
			concate = ""
				
			groups.each do |g|
			
				if self.is_bundle?(g)
						
					break
							
				end
				
				concate +=  g + "/"
				group_ref = project.main_group.find_subpath(concate, true)
				group_ref.set_path(g)
				
			end
			
		end
	
	end

end