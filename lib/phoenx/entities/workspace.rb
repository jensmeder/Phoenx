module Phoenx

	class Workspace
	
		attr_accessor :name
		attr_accessor :main_project
		attr_reader   :projects
		
		def initialize
		
			@repositories = []
			@projects = {}

			yield(self)
		
		end
		
		def repository(folder, url, branch)
		
			@repositories << Repository.new(folder, url, branch)
		
		end
		
		def project(name, path)
		
			@projects[name] = path
		
		end
	
	end

end