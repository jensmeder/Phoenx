module Phoenx

	class Workspace
		attr_accessor :name
		attr_reader   :main_project_name
		attr_reader   :main_project_path
		attr_reader   :projects
		attr_reader   :generated_projects
		
		def initialize
			@main_project = {}
			@projects = {}
			@generated_projects = {}
			yield(self)
		end
		
		def project(name, path = nil, generate = true)
			@projects[name] = path
			if generate
				@generated_projects[name] = path
			end
		end
		
		def main_project(name, path = nil)
			@main_project_name = name
			@main_project_path = path
		end
	
	end

end