module Workbench

  # Web-server class
	class Application

		attr_reader :app

    # Initialize class
    #
    # @param [String] path path to working directory
		def initialize path
			@app = Rack::Builder.new {
				use Rack::Reloader, 0
				use Rack::CommonLogger
				use Rack::ShowExceptions
				use Rack::ContentLength

        # Set config for Compass and SASS
				Compass.configuration do |config|
					config.project_path = path
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
				use Rack::StaticCache, :urls => [ '/css', '/js', '/img', '/favicon.ico' ], :root => './public', :versioning => false

				run Workbench::DynamicHandler.new path
			}.to_app
		end

    # Start Unicorn server
    #
    # @param [Numeric] port port number
    # @param [Number] workers workers count
		def start port, workers
			Unicorn::HttpServer.new(@app, {
				:listeners => [port],
				:worker_processes => workers,
				:preload_app => true
			}).start.join
		end

	end

end
