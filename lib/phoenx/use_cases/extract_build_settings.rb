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
					extract_settings(config, 'xcconfig/' + target.name + '/')
				end
			end
		end
		
		def extract_project_settings
			FileUtils::mkdir_p 'xcconfig'
			@project.build_configuration_list.build_configurations.each do |config|
				extract_settings(config, 'xcconfig/')
			end
		end

		def extract_settings(config, to_folder)
			build_settings = config.build_settings.map { |key,values|
				key + ' = ' + (values.is_a?(String) ? values  : values.join(' '))
			}
			build_settings.sort!
			open(to_folder + config.name + '.xcconfig', 'w') { |file|
				build_settings.each { |setting| file.puts(setting) }
			}
		end
	
		def extract
			self.extract_target_settings
			self.extract_project_settings
		end
		
	end

end
