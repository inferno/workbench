module Workbench

	class Cli < Thor

		include Thor::Actions

		map '-T' => :help, 'h' => :help, 'i' => :init, 's' => :start

		def self.source_root
			File.join(File.dirname(__FILE__), '..', '..', 'template')
		end

		def self.destination_root
			$root
		end

		desc 'start [--port] [--workers]', 'Start server in current directory'
		long_desc 'Start server in current directory'
		method_option :port, :aliases => '-p', :type => :numeric, :default => 4000, :desc => 'Port'
		method_option :workers, :aliases => '-w', :type => :numeric, :default => 4, :desc => 'Workers'
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
				:listeners => [options[:port]],
				:worker_processes => options[:workers],
				:preload_app => true
			}).start.join
		end

		desc 'init [--js=frameworks]', 'Initialize empty project in current directory'
		long_desc 'Initialize empty project in current directory'
		method_option :js, :type => :array, :default => ['jquery'], :desc => 'Install specific JS frameworks', :banner => 'jquery jquery-ui json'
		def init
			puts 'Create empty project'
			empty_directory 'haml'
			empty_directory 'sass'
			empty_directory 'public/css'
			empty_directory 'public/js'
			empty_directory 'public/img'

			copy_file 'normalize.scss', 'sass/normalize.scss'

			unless options[:js].include? 'jquery'
				options[:js].push('jquery')
			end

			invoke :js

			copy_file 'scripts.js', 'public/js/scripts.js'
			copy_file 'style.sass', 'sass/style.sass'
			copy_file 'index.haml', 'haml/index.haml'
			copy_file 'Gemfile', 'Gemfile'
			copy_file '.rvmrc', '.rvmrc'
		end

		desc 'js [--js=frameworks]', 'Add javascript library to project'
		method_option :js, :type => :array, :desc => 'Install specific JS frameworks', :banner => 'jquery jquery-ui json'
		method_option :list, :default => false, :desc => 'Show available frameworks', :banner => ''
		def js
			js_libs = Workbench::JSLibs.list

			if options[:list]
				puts 'Available JS library'
				js_libs.each do |index, item|
					puts " * #{index} => #{item}"
				end
			else
				options[:js].each do |js|
					if js_libs[js]
						get js_libs[js], "public/js/#{File.basename(js_libs[js])}"
					end
				end if options[:js]
			end
		end

		desc 'export [PATH]', 'Export project'
		def export path = 'export'
			full_path = "#{$root}/haml"
			export_path = "#{$root}/#{path}"
			puts 'Export project'
			directory "#{$root}/public", path
			views = glob_path full_path
			views.reject! { |v| v =~ /(^_|\/_)/ }
			browser = Rack::Test::Session.new(Rack::MockSession.new(Workbench::Server.new))
			FileUtils.rm_rf "#{export_path}/.tmp"
			Dir.mkdir "#{export_path}/.tmp"
			views.each do |filename|
				browser.get filename, {}, {'REQUEST_URI' => "http://example.org/#{extract_request_path(filename)}"}
				response = browser.last_response
				contents = response.body
				File.open("#{export_path}/.tmp/#{filename.gsub('.haml', '.html')}", 'w+') { |f| f.puts contents }
			end
			directory "#{export_path}/.tmp", export_path
			FileUtils.rm_rf "#{export_path}/.tmp"
		end

		no_tasks do

			def glob_path(path, directories = false)
				result = nil
				FileUtils.cd(path) do
					result = Dir.glob("**/*", File::FNM_DOTMATCH)
					result.reject! { |fn| File.directory?(fn) } unless directories
					result.reject! { |fn| %r{(^|/)(\.{1,2}|\.empty)$}.match(fn) }
					result.reject! { |fn| %r{\(.git(/|$)}.match(fn) }
				end
				result.sort!
				result
			end

			def remove_ext(path)
				if path =~ /^(.*?)\.[A-Za-z]+[A-Za-z.]*$/
					$1
				else
					path
				end
			end

			def extract_ext(path)
				if path =~ /(\.[A-Za-z]+)\.[A-Za-z]+$/
					$1
				elsif path =~ /(\.[A-Za-z]+)$/
					$1
				else
					''
				end
			end

			def extract_request_path(filename)
				result = remove_ext(filename)
				result = result.sub(/index$/, '')
				result = result.sub(/\/$/, '')
				result
			end

		end

	end

end
