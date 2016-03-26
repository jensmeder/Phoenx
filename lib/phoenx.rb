require 'colored'
require 'git'
require 'xcodeproj'

require 'phoenx/gem_version'
require 'phoenx/constants'

require 'phoenx/entities/cli/option'
require 'phoenx/entities/cli/command'
require 'phoenx/entities/project'
require 'phoenx/entities/target'
require 'phoenx/entities/configuration'
require 'phoenx/entities/scheme'
require 'phoenx/entities/workspace'
require 'phoenx/entities/repository'

require 'phoenx/use_cases/generate_workspace'
require 'phoenx/use_cases/generate_project'
require 'phoenx/use_cases/generate_target'

require 'phoenx/utilities/xcodeproj_utils'