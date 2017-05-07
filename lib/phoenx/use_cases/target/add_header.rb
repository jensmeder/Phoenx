module Phoenx

	module Target

		class HeaderBuilder
			attr_reader :project
			attr_reader :target
			attr_reader :target_spec
			attr_reader :umbrella_headers

			def initialize(project, target, target_spec)
				@project = project
				@target = target
				@target_spec = target_spec
				@umbrella_headers = []
			end

			def build
				self.add_public_headers
				self.add_project_headers
				self.add_private_headers
				self.generate_umbrella_header
			end
			
			def add_public_headers
				self.add_headers(@target_spec.public_headers, ATTRIBUTES_PUBLIC_HEADERS, true)
			end

			def add_project_headers
				self.add_headers(@target_spec.project_headers, ATTRIBUTES_PROJECT_HEADERS, true)
			end
			
			def add_private_headers
				self.add_headers(@target_spec.private_headers, ATTRIBUTES_PRIVATE_HEADERS, false)
			end
			
			def generate_umbrella_header
				unless @target_spec.umbrella_header == nil
					entries = @umbrella_headers.map{ |header| 
						unless @target_spec.module_name == nil
							import = '<' + @target_spec.module_name + '/' + File.basename(header) + '>'
						else
							import = '"'  + File.basename(header) + '"'
						end
						'#import ' + import
					}.sort
					open(@target_spec.umbrella_header, "w") { |file| 
						entries.each { |header| file.puts header }
					}
					self.add_header(@target_spec.umbrella_header, ATTRIBUTES_PUBLIC_HEADERS)
				end
			end

			def add_headers(header_files, attributes, add_to_umbrella_header)
				headers = Phoenx.merge_files_array(header_files)
				unless !header_files || header_files.empty? || !headers.empty?
					puts "No #{attributes["ATTRIBUTES"].first} headers found".yellow
				end
				Phoenx.add_groups_for_files(@project, headers)
				headers.each do |header|
					self.add_header(header, attributes)
				end
				if add_to_umbrella_header
					@umbrella_headers += headers
				else 
					@umbrella_headers -= headers
				end
			end

			def add_header(header, attributes)
				file = Phoenx.get_or_add_file(@project, header)
				build_file = @target.headers_build_phase.add_file_reference(file, true)
				build_file.settings = attributes
			end

		end

	end

end
