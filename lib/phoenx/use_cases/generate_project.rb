module Phoenx

	class GenerateProject
	
		:project_spec
		:project
	
		def initialize(project_spec)
			@project_spec = project_spec
		end
		
		def build
			@project_spec.pre_install_scripts.each do |pre_script|
				abort "Missing pre install script ".red + pre_script.bold unless File.exists?(pre_script)
				puts `./#{pre_script}`
			end
			# Build Project
			@project = Xcodeproj::Project::new(@project_spec.project_file_name)
			self.generate_configurations
			self.add_config_files
			self.add_support_files
			self.build_targets
			@project.main_group.sort_recursively
			if @project_spec.deterministic_project
				@project.predictabilize_uuids
			end
			@project.save(@project_spec.project_file_name)	
			@project_spec.post_install_scripts.each do |post_script|
				abort "Missing post install script ".red + post_script.bold unless File.exists?(post_script)
				puts `./#{post_script}`
			end	
		end
		
		def build_targets
			@project_spec.targets.each do |target|
				if target.target_type == :application
					builder = ApplicationTargetBuilder.new @project, target, @project_spec
					builder.build
				elsif target.target_type == :framework
					builder = FrameworkTargetBuilder.new @project, target, @project_spec
					builder.build
				end
			end
		end
		
		def generate_configurations
			@project_spec.configurations.each do |config|
				@project.add_build_configuration(config.name, config.parent)
			end
		end
		
		def add_config_files
			Phoenx::add_groups_for_files(@project,@project_spec.config_files.values)
			@project_spec.config_files.keys.each do |config|
				file_name = @project_spec.config_files[config]
				unless file_name == nil
					g = @project.main_group.find_subpath(File.dirname(file_name), false)
					file = g.find_file_by_path(File.basename(file_name))
					unless file != nil
						file = g.new_reference(File.basename(file_name))
					end
					configuration = @project.build_configuration_list[config]
					unless configuration
						abort "Config file assigned to invalid configuration '#{config}'' ".red + file_name.bold
					end
					configuration.base_configuration_reference = file
				end
			end
		end

		def add_support_files
			files = Phoenx.merge_files_array(@project_spec.support_files, @project_spec.excluded_support_files)
			Phoenx.get_or_add_files(@project, files)
		end
	
	end

end