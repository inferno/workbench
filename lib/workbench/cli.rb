module Workbench

	class Cli < Thor

		include Thor::Actions

		map '-T' => :help, 'h' => :help, 'i' => :init, 's' => :start

		def self.source_root
			File.join(File.dirname(__FILE__), '..', '..', 'template')
		end

		desc 'start', 'Start server in current directory'
		def start
			puts 'Starting HTTP server...'
			app = Rack::Builder.new {
				use Rack::Reloader, 0
				use Rack::CommonLogger
				use Rack::ShowExceptions
				use Rack::ContentLength

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
				use Rack::StaticCache, :urls => [ '/css', '/js', '/img', '/favicon.ico' ], :root => './public', :versioning => false

				run Workbench::Server.new
			}.to_app

			Unicorn::HttpServer.new(app, {
				:listeners => [4000],
				:preload_app => true,
				:worker_processes => 4
			}).start.join
		end

		desc 'init', 'Initialize empty project'
		method_option :js, :type => :array, :default => ['jquery'], :desc => 'Javascript library list'
		def init
			empty_directory 'haml'
			empty_directory 'sass'
			empty_directory 'public/css'
			empty_directory 'public/js'
			empty_directory 'public/img'

			get 'https://raw.github.com/jonathantneal/normalize.css/master/normalize.min.css', 'sass/_normalize.scss'

			library = {
				'jquery' => 'http://code.jquery.com/jquery.min.js'
			}

			options[:js].each do |js|
				if library[js]
					get library[js], 'public/js/jquery.min.js'
				end
			end

			copy_file 'style.sass', 'sass/style.sass'
			copy_file 'index.haml', 'haml/index.haml'
			copy_file 'Gemfile', 'Gemfile'
			copy_file '.rvmrc', '.rvmrc'
		end

	end

end
