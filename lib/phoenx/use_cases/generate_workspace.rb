require 'colored'

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
			path = value
			if path == nil
				path = '.'
			end
			abort "Missing project folder ".red + path.bold unless Dir.exists?(path)
			Dir.chdir(path) do
				file_name = name + '.' + PROJECT_EXTENSION
				specs = Dir[file_name]
				puts "> Project ".green + name.bold
				abort "Missing project specification ".red + (path + file_name).bold unless specs.first
				file = File.read(specs.first)
				spec = eval(file)
				generator = Phoenx::GenerateProject.new spec
				generator.build
			end
		end
		
		def generate_projects
			@workspace.generated_projects.each do |key,value| 
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
