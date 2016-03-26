module Phoenx

	class GenerateWorkspace
	
		:project_files
		:workspace
	
		def initialize(workspace)

			@workspace = workspace
			@project_files = []
		
		end
		
		def generate_workspace
		
			workspace = Xcodeproj::Workspace.new(@workspace.main_project + "." + XCODE_PROJECT_EXTENSION)

			@project_files.each do |project|

				workspace << project

			end

			workspace.save_as(@workspace.name + "." + XCODE_WORKSPACE_EXTENSION)
		
		end
		
		def generate_projects
		
			@workspace.projects.keys.each do |key,value| 
			
				path = value
				if path == nil
				
					path = Dir.pwd
				
				end
				
				Dir.chdir(path)
				specs = Dir['*.' + PROJECT_EXTENSION]
			
				file = File.read(specs.first)
				spec = eval(file)
			
				generator = Phoenx::GenerateProject.new spec, @workspace
				generator.build
			
				Dir.chdir(path)
			
			end
		
		end
		
		def generate

			self.generate_projects
			self.generate_workspace
		
		end
	
	end

end
