require "workbench/version"
require "workbench/dependencies"
require 'workbench/server'
require 'workbench/haml_helpers'

#module Workbench
#  # Your code goes here...
#end

$root = ENV['PWD']

app = Rack::Builder.new {
	use Rack::Reloader, 0
	use Rack::CommonLogger
	use Rack::ShowExceptions
	use Rack::ContentLength
	use Rack::Cache,
			:verbose => false

	sass_options = {
		:cache => true,
		:cache_store => Sass::CacheStores::Memory.new,
		:syntax => :sass,
		:style => :compact
	}

	use Rack::SassCompiler,
			:source_dir => File.join($root, 'sass'),
			:url => '/css',
			:sass_options => sass_options

	use Rack::SassCompiler,
			:source_dir => File.join($root, 'sass'),
			:url => '/css',
			:sass_options => sass_options.merge({ :syntax => :scss })


	use Rack::Static, :urls => ['/css', '/js', '/img'], :root => './public'

	run Server.new
}.to_app

Unicorn::HttpServer.new(app, {
	:listeners => [4000],
	:preload_app => true,
	:worker_processes => 4
}).start.join

