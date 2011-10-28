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
	use Rack::ShowStatus

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
		config.output_style = :compact
		config.line_comments = false
	end

	Compass.configure_sass_plugin!

	use Sass::Plugin::Rack
	use Rack::Static, :urls => ['/css', '/js', '/img'], :root => './public'

	run Workbench::Server.new
}.to_app

Unicorn::HttpServer.new(app, {
	:listeners => [4000],
	:preload_app => true,
	:worker_processes => 4
}).start.join

