module Phoenx

	class AbstractTarget
		attr_accessor :name
		attr_accessor :resources
		attr_accessor :excluded_resources
		attr_accessor :frameworks
		attr_accessor :libraries
		attr_accessor :sources
		attr_accessor :excluded_sources
		attr_accessor :system_frameworks
		attr_accessor :system_libraries
		attr_accessor :pre_build_scripts
		attr_accessor :post_build_scripts
		attr_accessor :support_files
		attr_accessor :excluded_support_files
		attr_reader   :dependencies
		attr_reader :config_files
		
		def initialize
			@dependencies = []
			@config_files = {}
			@frameworks = []
			@libraries = []
			@system_frameworks = []
			@system_libraries = []
			@pre_build_scripts = []
			@post_build_scripts = []
			@resources = []
			@excluded_resources = []
			@sources = []
			@excluded_sources = []
			@support_files = []
			@excluded_support_files = []
		end
		
		def dependency(target_name, embed = true, path = nil)
			dependencies << Dependency.new(target_name, embed, path)
		end
	
	end
	
	class TestableTarget < AbstractTarget
		attr_reader :test_targets
		attr_reader :extensions
		attr_reader :watch_apps
		attr_reader :schemes
		attr_accessor :version
		attr_accessor :platform
		attr_accessor :target_type
		attr_accessor :sub_projects
		attr_accessor :private_headers
		attr_accessor :excluded_private_headers
		attr_accessor :project_headers
		attr_accessor :excluded_project_headers
		attr_accessor :public_headers
		attr_accessor :excluded_public_headers
		attr_accessor :umbrella_header
		attr_accessor :module_name
		attr_accessor :archive_configuration
		attr_accessor :launch_configuration
		attr_accessor :analyze_configuration
		attr_accessor :profile_configuration
		attr_accessor :code_coverage_enabled
	
		public
		
		def initialize(name, type, platform, version)
			super()
			@test_targets = []
			@extensions = []
			@watch_apps = []
			@schemes = []
			@name = name
			@target_type = type
			@platform = platform
			@version = version
			@sub_projects = []
			@private_headers = []
			@excluded_private_headers = []
			@project_headers = []
			@excluded_project_headers = []
			@public_headers = []
			@excluded_public_headers = []
			@archive_configuration = 'Debug'
			@launch_configuration = 'Debug'
			@analyze_configuration = 'Debug'
			@profile_configuration = 'Debug'
			@code_coverage_enabled = false
			yield(self)
		end
		
		def test_target(name, &block)
			target = Phoenx::TestTarget.new &block
			target.name = name
			@test_targets << target
		end
		
		def extension_target(name, &block)
			target = Phoenx::TestableTarget.new name, nil, nil, nil, &block
			@extensions << target
		end

		def watch_target(name, type, platform, version, &block)
			target = Phoenx::TestableTarget.new name, type, platform, version, &block
			@watch_apps << target
		end

		def scheme(name, &block)
			@schemes << Phoenx::Scheme.new(name, block)
		end
	
	end
	
	class TestTarget < AbstractTarget
	
		public
	
		def initialize
			super
			yield(self)
		end
	
	end

end
