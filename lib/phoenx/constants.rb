module Phoenx
  
  	WORKSPACE_EXTENSION        = "pxworkspace"
  	PROJECT_EXTENSION          = "pxproject"
  	XCODE_PROJECT_EXTENSION    = "xcodeproj"
  	XCODE_WORKSPACE_EXTENSION  = "xcworkspace"
  	
  	SOURCE_EXTENSIONS 	= [".swift", ".m", ".c", ".xcdatamodeld"]
	RESOURCES_ROOT 		= "Resources"
	TESTS_ROOT 			= "Tests"
	SOURCE_ROOT 		= "Source"
	FRAMEWORKS_ROOT 	= "Frameworks"
	CONFIGURATION_ROOT 	= "Configuration"
	XCTEST_EXTENSION 	= "xctest"
	APP_EXTENSION 		= "app"
	EXTENSION_EXTENSION = "appex"
	
	ATTRIBUTES_CODE_SIGN_ON_COPY 	= {"ATTRIBUTES" => ["CodeSignOnCopy"]}
	ATTRIBUTES_PUBLIC_HEADERS 		= {"ATTRIBUTES" => [:Public]}
	ATTRIBUTES_PRIVATE_HEADERS 		= {"ATTRIBUTES" => [:Private]}
	ATTRIBUTES_PROJECT_HEADERS 		= {"ATTRIBUTES" => [:Project]}
  
end