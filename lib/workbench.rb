require 'workbench/version'
require 'workbench/dependencies'
require 'workbench/js_libs'
require 'workbench/cli'
require 'workbench/server'
require 'workbench/renderer'
require 'workbench/haml_helpers'

$root = ENV['PWD']

Workbench::Cli.start

