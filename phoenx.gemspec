# coding: utf-8

require File.expand_path('../lib/phoenx/gem_version', __FILE__)
require 'date'

Gem::Specification.new do |spec|
  spec.name          = "phoenx"
  spec.version       = Phoenx::VERSION
  spec.date     	 = Date.today
  spec.authors       = ["Jens Meder"]
  spec.email         = ["gems@jensmeder.de"]
  spec.description	 = "An Xcode Project and Workspace Generator"
  spec.summary       = "Phoenx generates Xcode projects (*.xcodeproj) and workspaces (*.xcworkspace) for iOS, OSX, and tvOS using specification and xcconfig files. Specify your project once and never worry about broken Xcode projects or merge conflicts in pbxproj files ever again."
  spec.homepage      = "https://www.github.com/jensmeder/Phoenx"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"]

  spec.executables   << "phoenx"

  spec.add_runtime_dependency "xcodeproj", "~> 1.4.0"
  spec.add_runtime_dependency "colored", "~> 1.2"
  
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rspec", "~> 3.0"
end