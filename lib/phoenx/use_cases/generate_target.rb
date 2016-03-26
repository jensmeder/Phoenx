module Phoenx

	class TargetBuilder
	
		attr_reader :project
		
		attr_reader :target_spec
		attr_reader :workspace_spec
		attr_reader :project_spec
		attr_reader :framework_files
		
		def initialize(project, target_spec, workspace_spec, project_spec)
		
			@project = project
			@target_spec = target_spec
			@workspace_spec = workspace_spec
			@project_spec = project_spec
			@framework_files = []
		
		end
		
		def add_support_files
		
			Phoenx.get_or_add_files(@project, @target_spec.support_files)
		
		end
		
		def add_frameworks_and_libraries
	
			# Add Framework dependencies

			frameworks_group = @project.main_group.find_subpath(FRAMEWORKS_ROOT, true)

			@target_spec.frameworks.each do |framework|

				file = Phoenx.get_or_add_file(@project,framework)
				@framework_files << file
			
				self.target.frameworks_build_phases.add_file_reference(file)

			end
			
			@target_spec.libraries.each do |framework|

				file = Phoenx.get_or_add_file(@project,framework)
				self.target.frameworks_build_phases.add_file_reference(file)

			end
	
		end
		
		def add_build_phase_scripts

			@target_spec.pre_build_scripts.each do |script|
			
				phase = self.target.new_shell_script_build_phase(script[:name])
				phase.shell_script = script[:script]
				
				self.target.build_phases.move(phase, 0)
			
			end
			
			@target_spec.post_build_scripts.each do |script|
			
				phase = self.target.new_shell_script_build_phase(script[:name])
				phase.shell_script = script[:script]
				
				self.target.build_phases.move(phase, self.target.build_phases.count - 1)
			
			end
		
		end
		
		def add_system_dependencies
	
			# Add Framework dependencies

			@target_spec.system_frameworks.each do |framework|

				self.target.add_system_framework(framework)

			end
		
			@target_spec.system_libraries.each do |library|

				self.target.add_system_library(library)

			end
	
		end
		
		def add_resources
	
			# Add Resource files
			resources = Phoenx.merge_files_array(@target_spec.resources)
			
			Phoenx.add_groups_for_files(@project, resources)

			resources.each do |source|
			
				file = nil
				
				if self.is_bundle?(source)
				
					parts = source.split("/")
					
					group = @project.main_group
					
					parts.each do |part|
						
						if self.is_bundle?(part)
							
							file = group.find_file_by_path(part)
							
							unless file != nil
							
								file = group.new_file(part)
								self.target.resources_build_phase.add_file_reference(file)
							
							end
							
							break
							
						else
						
							group = group.find_subpath(part, false)
						
						end
					
					end
				
				else
				
					group = @project.main_group.find_subpath(File.dirname(source), false)
				
					unless group == nil
						
						file = group.find_file_by_path(File.basename(source))
							
						unless file != nil
							
							file = group.new_file(File.basename(source))
							self.target.resources_build_phase.add_file_reference(file)
							
						end
				
					end
					
				
				end

			end
	
		end
		
		def add_sources
	
			# Add Source files
			sources = Phoenx.merge_files_array(@target_spec.sources)
			
			Phoenx.add_groups_for_files(@project, sources)

			sources.each do |source|

				file = Phoenx.get_or_add_file(@project,source)
	
				# Add to Compile sources phase

				unless File.extname(source) == ".h" || File.extname(source) == ".pch"
				
					self.target.add_file_references([file])
				
				end

			end
	
		end
		
		def add_headers(header_files,attributes)
		
			headers = Phoenx.merge_files_array(header_files)

			Phoenx.add_groups_for_files(@project, headers)

			headers.each do |header|
			
				file = Phoenx.get_or_add_file(@project,header)
	
				build_file = self.target.headers_build_phase.add_file_reference(file, true)
				build_file.settings = attributes

			end
	
		end
		
		def add_public_headers
		
			self.add_headers(@target_spec.public_headers,ATTRIBUTES_PUBLIC_HEADERS)
	
		end
		
		def add_private_headers
		
			self.add_headers(@target_spec.private_headers,ATTRIBUTES_PRIVATE_HEADERS)
	
		end
		
		def add_project_headers
		
			self.add_headers(@target_spec.project_headers,ATTRIBUTES_PROJECT_HEADERS)
	
		end
		
		def add_config_files
		
			# Add configuration group
			
			Phoenx.add_groups_for_files(@project, @target_spec.config_files.values)
		
			@target_spec.config_files.each do |config,file_name|

				unless file_name == nil
				
					file = Phoenx.get_or_add_file(@project,file_name)
					
					configuration = self.target.build_configuration_list[config]
					
					unless configuration == nil
						configuration.base_configuration_reference = file
					end
				
				end
			
			end
		
		end
		
		def build
		
		end
		
		def target
		
			return nil
		
		end
	
	end

	class TestableTargetBuilder < TargetBuilder
	
		:test_target
		
		def generate_target_scheme
		
			# Generate main scheme
	
			scheme = Xcodeproj::XCScheme.new
			scheme.configure_with_targets(self.target, @test_target)
			scheme.test_action.code_coverage_enabled = true
			scheme.add_build_target(self.target, true)
			
			scheme.save_as(@project_spec.project_file_name, @target_spec.name, false)	
		
		end
		
		def configure_target
		
			Phoenx.set_target_build_settings_defaults(self.target)
			Phoenx.set_project_build_settings_defaults(@project)
		
		end
		
		def sort_build_phases
		
			self.target.build_phases.objects.each do |phase|
			
				phase.sort
				
			end
		
		end
		
		def add_sub_projects
	
			frameworks_group = @project.main_group.find_subpath(FRAMEWORKS_ROOT, true)

			@target_spec.sub_projects.each do |sub_project|

				path = sub_project
				file = frameworks_group.new_reference(path)
				project = Xcodeproj::Project::open(path)
				self.target.add_dependency(project.targets.first)
				
			end
	
		end
		
		def add_schemes
		
			@target_spec.schemes.each do |s|
			
				scheme = Xcodeproj::XCScheme.new
				scheme.configure_with_targets(self.target, @test_target)
				scheme.test_action.code_coverage_enabled = true
				scheme.add_build_target(self.target, true)
				scheme.add_test_target(@test_target)
				
				scheme.archive_action.build_configuration = self.target.build_configuration_list[s.archive_configuration]
				scheme.launch_action.build_configuration = self.target.build_configuration_list[s.launch_configuration]
			
				scheme.save_as(@project_spec.project_file_name, s.name, false)
			
			end
		
		end
		
		def add_test_targets
		
			@target_spec.test_targets.each do |test_target_spec|
			
				builder = TestTargetBuilder.new(@target, @project, test_target_spec, @workspace_spec, @project_spec, @target_spec, self.framework_files)
				builder.build
				
				@test_target = builder.target
			
			end	
		
		end
		
		def build
			
			self.add_sources
			self.add_public_headers
			self.add_private_headers
			self.add_project_headers
			self.add_resources
			self.configure_target
			self.add_config_files
			self.add_sub_projects
			self.add_system_dependencies
			self.add_frameworks_and_libraries
			self.add_build_phase_scripts
			
			self.add_test_targets
			self.generate_target_scheme
			self.add_schemes
			self.add_support_files
			self.sort_build_phases
		
		end
	
	end
	
	class ApplicationTargetBuilder < TestableTargetBuilder
	
		:target
		:copy_frameworks
		
		def add_sub_projects
	
			frameworks_group = @project.main_group.find_subpath(FRAMEWORKS_ROOT, true)

			@target_spec.sub_projects.each do |sub_project|

				path = sub_project

				file = frameworks_group.new_reference(path)
				project = Xcodeproj::Project::open(path)
				self.target.add_dependency(project.targets.first)

				build_file = @copy_frameworks.add_file_reference(file.file_reference_proxies.first)
				build_file.settings = ATTRIBUTES_CODE_SIGN_ON_COPY
				
			end
	
		end
	
		def build
		
			@target = @project.new_target(@target_spec.target_type, @target_spec.name, @target_spec.platform, @target_spec.version)
			@copy_frameworks = @target.new_copy_files_build_phase
			@copy_frameworks.symbol_dst_subfolder_spec = :frameworks
			
			super()
			
			self.framework_files.each do |file|

				build_file = @copy_frameworks.add_file_reference(file)
				build_file.settings = ATTRIBUTES_CODE_SIGN_ON_COPY

			end
		end
		
		def target
		
			return @target
		
		end
	
	end
	
	class FrameworkTargetBuilder < TestableTargetBuilder
	
		:target
	
		def build

			@target = @project.new_target(@target_spec.target_type, @target_spec.name, @target_spec.platform, @target_spec.version)
			super()
			
		end
		
		def target
		
			return @target
		
		end
	
	end
	
	class TestTargetBuilder < TargetBuilder
	
		:target
		:main_target
		:main_target_spec
		:main_target_frameworks_files
		
		def initialize(main_target, project, target_spec, workspace_spec, project_spec, main_target_spec, main_target_frameworks_files)
		
			super(project, target_spec, workspace_spec, project_spec)
			@main_target = main_target
			@main_target_spec = main_target_spec
			@main_target_frameworks_files = main_target_frameworks_files
		
		end
	
		def build
	
			@target = @project.new(Xcodeproj::Project::PBXNativeTarget)
			@project.targets << @target
			@target.name = @target_spec.name
			@target.product_name = @target_spec.name
			@target.product_type = Xcodeproj::Constants::PRODUCT_TYPE_UTI[:unit_test_bundle]
			@target.build_configuration_list = Xcodeproj::Project::ProjectHelper.configuration_list(@project, @main_target_spec.platform, @main_target_spec.version)

			product_ref = @project.products_group.new_reference(@target_spec.name + '.' + XCTEST_EXTENSION, :built_products)
			product_ref.include_in_index = '0'
			product_ref.set_explicit_file_type
			@target.product_reference = product_ref

			@target.build_phases << @project.new(Xcodeproj::Project::PBXSourcesBuildPhase)
			@target.build_phases << @project.new(Xcodeproj::Project::PBXFrameworksBuildPhase)
			@target.build_phases << @project.new(Xcodeproj::Project::PBXResourcesBuildPhase)
		
			self.add_sources
			self.add_config_files
			self.add_frameworks_and_libraries
			self.add_system_dependencies
			
			self.add_build_phase_scripts
			self.add_resources
			self.add_support_files
			
			copy_frameworks = @target.new_copy_files_build_phase
			copy_frameworks.symbol_dst_subfolder_spec = :frameworks
		
			frameworks_group = @project.main_group.find_subpath(FRAMEWORKS_ROOT, false)
		
			self.framework_files.each do |file|
		
				build_file = copy_frameworks.add_file_reference(file)
				build_file.settings = ATTRIBUTES_CODE_SIGN_ON_COPY
		
			end
			
			@main_target_frameworks_files.each do |file|
		
				build_file = copy_frameworks.add_file_reference(file)
				build_file.settings = ATTRIBUTES_CODE_SIGN_ON_COPY
		
			end
			
			# Add target dependency.
			@target.add_dependency(@main_target)
	
		end
		
		def target
		
			return @target
		
		end
	
	end

end