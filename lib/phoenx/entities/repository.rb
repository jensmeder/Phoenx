module Phoenx

	class Repository
	
		attr_reader :folder
		attr_reader :url
		attr_reader :branch
		
		def initialize(folder, url, branch)
		
			@folder = folder
			@url = url
			@branch = branch
		
		end
	
	end

end