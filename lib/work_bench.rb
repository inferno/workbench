require 'work_bench/version'
require 'work_bench/dependencies'
require 'work_bench/js_libs'
require 'work_bench/application'
require 'work_bench/cli'
require 'work_bench/server'
require 'work_bench/renderer'
require 'work_bench/haml_helpers'
require 'work_bench/exporter'

$root = ENV['PWD']

Workbench::Cli.start

