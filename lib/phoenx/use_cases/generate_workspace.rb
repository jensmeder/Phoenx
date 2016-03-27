module Phoenx

	class GenerateWorkspace
	
		:project_files
		:workspace
	
		def initialize(workspace)

			@workspace = workspace
			@project_files = []
		
		end
		
		def generate_workspace
		
			workspace = Xcodeproj::Workspace.new(@workspace.main_project_path + @workspace.main_project_name + "." + XCODE_PROJECT_EXTENSION)

			@workspace.projects.each do |key,value| 

				workspace << value + key + "." + XCODE_PROJECT_EXTENSION

			end

			workspace.save_as(@workspace.name + "." + XCODE_WORKSPACE_EXTENSION)
		
		end
		
		def generate_project(name, value)
		
			previous = Dir.pwd
			path = value
			if path == nil
		
				path = Dir.pwd
				
			end
				
			Dir.chdir(path)
				
			specs = Dir[name + '.' + PROJECT_EXTENSION]

			file = File.read(specs.first)
			spec = eval(file)
			
			generator = Phoenx::GenerateProject.new spec, @workspace
			generator.build
			
			Dir.chdir(previous)
		
		end
		
		def generate_projects
		
			@workspace.projects.each do |key,value| 
			
				self.generate_project(key,value)
			
			end
			
			self.generate_project(@workspace.main_project_name,@workspace.main_project_path)
		
		end
		
		def generate

			self.generate_projects
			self.generate_workspace
		
		end
	
	end

end
