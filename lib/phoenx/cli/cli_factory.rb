module Phoenx

	module Cli

		class Factory
		
			def workspace_command

				command = Phoenx::Cli::Command.new "workspace", "Builds the workspace and projects" do
	
					command.print
					exit

				end

				command.base_command = "phoenx workspace"
				command.usage = "Initializes the workspace by generating the xcodeproj and xcworkspace files."

				# Add workspace build command

				build_command = Phoenx::Cli::Command.new "build", "Builds the workspace and projects" do

					workspaces = Dir["*." + Phoenx::WORKSPACE_EXTENSION]
	
					if workspaces.count < 1

						puts "Error: No workspace spec found!".red
						exit

					end

					workspace = eval File.read(workspaces.first)
	
					if !workspace

						puts "Error: No workspace spec found!".red
						exit

					end

					puts "\r\nGenerating projects and workspace".green
		
					generator = Phoenx::GenerateWorkspace.new workspace
					generator.generate
	
					exit

				end
	

				build_command.base_command = "phoenx workspace"
				build_command.usage = "Initializes the workspace by generating the xcodeproj and xcworkspace files."

				build_help_option = Phoenx::Cli::Option.new("--help", "-h","Shows this help",false) do
					build_command.print
					exit
				end

				build_command.add_option build_help_option
	
				command.add_command build_command
	
				return command

			end
		
			def cli
			
				# Build cli

				cli = Phoenx::Cli::Command.new "root", "" do |c|

					c.print

				end

				cli.base_command = "phoenx"

				# Add project command

				project_command = Phoenx::Cli::Command.new "project", "Builds the project" do
	
					project_command.print
					exit

				end

				project_command.base_command = "phoenx project"
				project_command.usage = "Initializes the project by generating the xcodeproj file."



				# Add version and help options

				version_option = Phoenx::Cli::Option.new("--version","-v","Shows version information",false) do
					puts "phoenx version " + Phoenx::VERSION.bold
	
					exit
				end

				help_option = Phoenx::Cli::Option.new("--help","-h","Shows this help",false) do
					cli.print
					exit
				end

				cli.add_option version_option
				cli.add_option help_option

				cli.add_command workspace_command
				cli.add_command project_command
				
				return cli
			
			end
		
		end
	
	end

end