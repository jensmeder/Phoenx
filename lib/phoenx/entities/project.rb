module Phoenx
	
	class Project
		attr_reader :configurations
		attr_reader :config_files
		attr_accessor :pre_install_scripts
		attr_accessor :post_install_scripts
		attr_accessor :project_name
		attr_accessor :support_files
		attr_accessor :excluded_support_files
		attr_reader   :targets
		attr_accessor :deterministic_project

		def initialize
			@configurations = []
			@config_files = {}
			@targets = []
			@pre_install_scripts = []
			@post_install_scripts = []
			@support_files = []
			@excluded_support_files = []
			@deterministic_project = false
			yield self
		end
		
		def configuration(name, parent)
			@configurations << Configuration.new(name, parent)
		end
		
		def target(name, type, platform, version, &block)
			targets << Phoenx::TestableTarget.new(name, type, platform, version, &block)
		end
		
		def project_file_name
			return @project_name + "." + XCODE_PROJECT_EXTENSION
		end
	
	end

end
