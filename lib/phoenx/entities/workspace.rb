module Phoenx

	class Workspace
	
		attr_accessor :name
		attr_accessor :main_project
		attr_reader   :projects
		
		def initialize
		
			@projects = {}

			yield(self)
		
		end
		
		def project(name, path = nil)
		
			@projects[name] = path
		
		end
	
	end

end