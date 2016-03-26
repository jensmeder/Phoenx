# coding: utf-8

require File.expand_path('../lib/phoenx/gem_version', __FILE__)
require 'date'

Gem::Specification.new do |spec|
  spec.name          = "phoenx"
  spec.version       = Phoenx::VERSION
  spec.date     	 = Date.today
  spec.authors       = ["Jens Meder"]
  spec.email         = ["gems@jensmeder.de"]
  spec.description	 = "An Xcode Project Generator"
  spec.summary       = "Generates xcode projects and workspaces from specification files"
  spec.homepage      = "https://www.github.com/jensmeder/Phoenx"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"]

  spec.executables   << "phoenx"

  spec.add_runtime_dependency "xcodeproj", "~> 1.0.0.beta.2"
  spec.add_runtime_dependency "git", "~> 1.2", ">= 1.2.9.1"
  spec.add_runtime_dependency "colored", "~> 1.2"
end