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
	
	def Phoenx.get_or_add_files(project, files)
	
		resources = Phoenx.merge_files_array(files)
			
		Phoenx.add_groups_for_files(project, resources)

		resources.each do |source|
				
			Phoenx.get_or_add_file(project,source)
				
		end
	
	end
	
	def Phoenx.get_or_add_file(project,file)
	
		filename = File.basename(file)
		dir = File.dirname(file)
		
		group = project.main_group.find_subpath(dir, false)
		file_ref = group.find_file_by_path(filename)
				
		unless file_ref != nil
				
			file_ref = group.new_file(filename)
				
		end	
		
		return file_ref
	
	end
	
	def Phoenx.set_target_build_settings_defaults(target)
		
		target.build_configuration_list.build_configurations.each do |config|

			config.build_settings.delete 'TARGETED_DEVICE_FAMILY'
			config.build_settings.delete 'CODE_SIGN_IDENTITY'
			config.build_settings.delete 'CODE_SIGN_IDENTITY[sdk=iphoneos*]'
			config.build_settings.delete 'DEBUG_INFORMATION_FORMAT'
			config.build_settings.delete 'PRODUCT_NAME'
			config.build_settings.delete 'DEFINES_MODULE'

		end
		
	end
	
	def Phoenx.set_project_build_settings_defaults(project)
	
		project.build_configuration_list.set_setting("FRAMEWORK_SEARCH_PATHS", "$(inherited)")
		project.build_configuration_list.set_setting("CODE_SIGN_IDENTITY", "$(inherited)")
		project.build_configuration_list.set_setting("CODE_SIGN_IDENTITY[sdk=iphoneos*]", "$(inherited)")
		project.build_configuration_list.set_setting("DEBUG_INFORMATION_FORMAT", "$(inherited)")
		project.build_configuration_list.set_setting("PRODUCT_NAME", "$(inherited)")
		project.build_configuration_list.set_setting("DEFINES_MODULE", "$(inherited)")
	
	end

end