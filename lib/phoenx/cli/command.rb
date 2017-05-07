module Phoenx

	module Cli
	
		class Command
	
			attr_accessor :name
			attr_accessor :description
			attr_accessor :base_command
			attr_accessor :usage
		
			@block
			@options
			@commands
		
			@@indent = 20
		
			def initialize(name, description, &block)
				@name = name
				@description = description
				@block = block
				@options = []
				@commands = []
			end
		
			def add_option(option)
				@options << option
			end
		
			def add_command(command)
				@commands << command
			end
		
			def parse(args)
				args_tmp = args.dup
				if args_tmp.empty?
					@block.call self
				else
					args_tmp.each do |arg|
						@commands.each do |command|
							if arg == command.name
								args_tmp.delete(arg)
								command.parse(args_tmp)
							end
						end
						@options.each do |option|
							if arg == option.name || arg == option.short_cut
								args_tmp.delete(arg)			
								option.execute
							end
						end
					end
				end
				unless args_tmp.empty?
					error = "Unknown arguments: "
					args_tmp.each do |arg|
						error += arg + " "
					end
					puts error
					print
					exit
				end
			end
		
			def print
				puts
				puts "Usage".underline
				puts
				cmd = "     $ ".bold + base_command
				unless @commands.empty?
					cmd += " " + "[command]".green.bold
				end
				unless @options.empty?
					cmd += " [options]".blue.bold
				end
				puts cmd
				unless @usage.nil?
					puts 
					puts "     " + @usage
				end
				if !@commands.empty?
					puts
					puts "Commands".underline
					puts
					@commands.each do |command|
						puts "     ".green + command.name.green.bold + whitespace(command.name) + command.description	
					end
				end
				if !@options.empty?
					puts
					puts "Options".underline
					puts
					@options.each do |option|
						output = option.name + ", " + option.short_cut
						puts "     " + output.bold.blue + whitespace(output) + option.description	
					end
				end
				puts
			end
		
			private
		
			def whitespace(message)
				count = @@indent - message.length
				i = 0
				result = ""
				until count == i do
					result << " "
					i += 1
				end
				return result
			end
	
		end
	
	end
	
end