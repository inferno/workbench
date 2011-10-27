require "workbench/version"
require "workbench/dependencies"
require 'workbench/server'
require 'workbench/haml_helpers'

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

	Compass.configuration do |config|
		config.project_path = $root
		config.http_path = '/'
		config.http_images_path = '/img'
		config.http_stylesheets_path = '/css'
		config.http_javascripts_path = '/js'
		config.sass_dir = 'sass'
		config.css_dir = 'public/css'
		config.images_dir = 'public/img'
		config.javascripts_dir = 'public/js'
		config.relative_assets = false
	end

	use Rack::SassCompiler,
			:source_dir => File.join($root, 'sass'),
			:url => '/css',
			:sass_options => sass_options

	use Rack::SassCompiler,
			:source_dir => File.join($root, 'sass'),
			:url => '/css',
			:sass_options => sass_options.merge({ :syntax => :scss })


	use Rack::Static, :urls => ['/css', '/js', '/img'], :root => './public'

	run Workbench::Server.new
}.to_app

Unicorn::HttpServer.new(app, {
	:listeners => [4000],
	:preload_app => true,
	:worker_processes => 4
}).start.join

