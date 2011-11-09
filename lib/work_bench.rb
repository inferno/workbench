require 'workbench/version'
require 'workbench/dependencies'
require 'workbench/js_libs'
require 'workbench/application'
require 'workbench/cli'
require 'workbench/server'
require 'workbench/renderer'
require 'workbench/haml_helpers'
require 'workbench/exporter'

$root = ENV['PWD']

Workbench::Cli.start

