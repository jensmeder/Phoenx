module Phoenx

	class Workspace
		attr_accessor :name
		attr_reader   :main_project_name
		attr_reader   :main_project_path
		attr_reader   :projects
		
		def initialize
			@main_project = {}
			@projects = {}
			yield(self)
		end
		
		def project(name, path = nil)
			@projects[name] = path
		end
		
		def main_project(name, path = nil)
			@main_project_name = name
			@main_project_path = path
		end
	
	end

end