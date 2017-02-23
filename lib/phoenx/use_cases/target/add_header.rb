module Phoenx

	module Target

		class HeaderBuilder

			attr_reader :project
			attr_reader :target
			
			attr_reader :target_spec

			def initialize(project, target, target_spec)
			
				@project = project
				@target = target

				@target_spec = target_spec

			end

			def build

				self.add_public_headers
				self.add_project_headers
				self.add_private_headers

			end
			
			def add_public_headers
			
				self.add_headers(@target_spec.public_headers, ATTRIBUTES_PUBLIC_HEADERS)
		
			end

			def add_project_headers
			
				self.add_headers(@target_spec.project_headers, ATTRIBUTES_PROJECT_HEADERS)
		
			end
			
			def add_private_headers
			
				self.add_headers(@target_spec.private_headers, ATTRIBUTES_PRIVATE_HEADERS)
		
			end

			def add_headers(header_files,attributes)
			
				headers = Phoenx.merge_files_array(header_files)

				unless !header_files || header_files.empty? || !headers.empty?
					puts "No #{attributes["ATTRIBUTES"].first} headers found".yellow
				end

				Phoenx.add_groups_for_files(@project, headers)

				headers.each do |header|
				
					file = Phoenx.get_or_add_file(@project,header)
		
					build_file = @target.headers_build_phase.add_file_reference(file, true)
					build_file.settings = attributes

				end
		
			end

		end

	end

end
