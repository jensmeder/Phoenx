[![Gem Version](https://badge.fury.io/rb/phoenx.svg)](https://badge.fury.io/rb/phoenx)

# Phoenx

Phoenx generates Xcode projects (`*.xcodeproj`) and workspaces (`*.xcworkspace`) for iOS, OSX, and tvOS using specification and xcconfig files. Specify your project once and never worry about broken Xcode projects or merge conflicts in pbxproj files ever again. 

#### Example

```ruby

Phoenx::Project.new do |s|
		
	s.project_name = "DarkLightning"
	
	# Set up project wide xcconfig files
	
	s.config_files["Debug"] = "Configuration/Shared/debug.xcconfig"
	s.config_files["Release"] = "Configuration/Shared/release.xcconfig"
	
	# When true, changes are avoided when regenerating the project file (useful when tracking it in version control)
	# When you see a "Generated duplicate UUIDs" warning after enabling this option, please create a bug report at https://github.com/jensmeder/Phoenx/issues.
	s.deterministic_project = true 

	# Add a new OSX framework target
	
	s.target "OSX", :framework, :osx, '10.11' do |target|
	
		target.config_files["Debug"] = "Configuration/OSX/debug.xcconfig"
		target.config_files["Release"] = "Configuration/OSX/release.xcconfig"
		
		# Add files to target
		
		target.support_files = ["Configuration/**/*.{xcconfig,plist}"]
		target.sources = "Source/Sockets/**/*.{h,m}", "Source/USB/**/*.{h,m,c}","Source/PacketProtocol/**/*.{h,m}", "Source/Internal/**/*.{h,m}"
		target.public_headers = "Source/OSX/**/*.{h}","Source/USB/*.{h}","Source/PacketProtocol/**/*.{h}","Source/USB/Connections/**/*.{h}"
		target.private_headers = ["Source/Sockets/**/*.{h}", "Source/USB/USBMux/**/*.{h}"]
		
		# Generate an umbrella header

			# Path to the file that should be generated
		target.umbrella_header = "Source/OSX/DarkLightning.h"
			
			# Optional: Defining the module name (results in `#import <Module/Header.h>` in comparison to `#import "Header.h"`)
		target.module_name = "DarkLightning"

		# Add a unit test target
		
		target.test_target "OSX-Tests" do |t|
		
			t.sources = ["Tests/**/*.{h,m,c}"]
			t.frameworks = ["Frameworks/Kiwi/Kiwi.framework"]
			t.config_files["Debug"] = "Configuration/OSXTests/debug.xcconfig"
			t.config_files["Release"] = "Configuration/OSXTests/release.xcconfig"
		
		end
	
	end

end

```

As soon as you run `phoenx project build` Phoenx will generate a new `xcodeproj` file based on the above definition. Easy as that!

## Overview

1. [Features](README.md#1-features)
2. [Requirements](README.md#2-requirements)
3. [Installation](README.md#3-installation)
4. [Getting Started](README.md#4-getting-started)
5. [Documentation](README.md#5-documentation)
6. [Available Commands](README.md#6-available-commands)
7. [License](README.md#7-license)

## 1. Features

* non intrusive: If you decide to skip using Phoenx there is no need to change anything in your projects or workspaces. 
* extract build settings from xcodeproj to xcconfig files
* generate xcodeproj and xcworkspace files using `pxproject` and `pxworkspace` specification files

## 2. Requirements

* Ruby 2.0.0 or higher
* Xcode 7 or higher

## 3. Installation

Phoenx is built with Ruby and can be installed via ruby gems. If you use the default Ruby installation on Mac OS X, `gem install` can require you to use `sudo` when installing gems. 

```ruby
$ gem install phoenx
```
## 4. Getting Started

You can find project templates for common Xcodeproj configurations in the `templates` folder. 

## 5. Documentation

You can find more details on how to use phoenx in the [Wiki](https://github.com/jensmeder/Phoenx/wiki).

## 6. Available Commands

```
$ phoenx [command] [options]
```

*Commands*

     workspace           Workspace related commands
     project             Project related commands

*Options*

     --version, -v       Shows version information
     --help, -h          Shows this help

### Project

```
$ phoenx project [command] [options]
```

*Commands*

     build               Builds the project
     extract             Extracts all build settings.
     
*Options*

     --help, -h          Shows this help

### Workspace

     $ phoenx workspace [command] [options]

*Commands*

     build               Builds the workspace and projects
     
*Options*

     --help, -h          Shows this help

## 7. License

The MIT License (MIT)

Copyright (c) 2016 Jens Meder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
