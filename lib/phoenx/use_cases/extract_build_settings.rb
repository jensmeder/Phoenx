module Phoenx

	class ExtractBuildSettings

		:project
	
		def initialize(project)
		
			@project = project
		
		end
		
		def extract_target_settings
		
			@project.targets.each do |target|
					
				FileUtils::mkdir_p 'xcconfig/' + target.name
					
				target.build_configuration_list.build_configurations.each do |config|
						
					file = open('xcconfig/' + target.name + '/' + config.name + '.xcconfig', 'w')
							
					config.build_settings.each do |key,values|
							
						file.write(key + ' = ')
								
						if values.is_a?(String)
								
							file.write(values)
									
						else
								
							values.each do |value|
								
								file.write(value + ' ')
								
							end
								
						end
								
						file.puts
							
					end
							
					file.close
						
				end
					
			end
		
		end
		
		def extract_project_settings
		
			FileUtils::mkdir_p 'xcconfig'
					
			@project.build_configuration_list.build_configurations.each do |config|
						
				file = open('xcconfig/' + config.name + '.xcconfig', 'w')
							
				config.build_settings.each do |key,values|
							
					file.write(key + ' = ')
								
					if values.is_a?(String)
								
						file.write(values)
									
					else
								
						values.each do |value|
								
							file.write(value + ' ')
								
						end
								
					end
								
					file.puts
							
				end
							
				file.close
						
			end
		
		end
	
		def extract
		
			self.extract_target_settings
			self.extract_project_settings
		
		end
		
	end

end
