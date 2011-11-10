module Workbench

	class Cli < Thor

		include Thor::Actions

		map '-T' => :help, 'h' => :help, 'i' => :init, 's' => :start, '-v' => :version

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

			app = Workbench::Application.new
			app.start options[:port], options[:workers]

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

			copy_file '_normalize.scss', 'sass/_normalize.scss'

			unless options[:js].include? 'jquery'
				options[:js].push('jquery')
			end

			invoke :js

			copy_file 'scripts.js', 'public/js/scripts.js'
			copy_file 'style.sass', 'sass/style.sass'
			copy_file 'index.haml', 'haml/index.haml'
			copy_file 'Gemfile', 'Gemfile'
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
		method_option :fix, :type => :boolean, :desc => 'Fix relative urls'
		def export path = 'export'
			export = Workbench::Exporter.new $root, File.join($root, path), options[:fix]
			export.process
		end

		desc 'version', 'Show gem version'
		def version
			puts "Version: #{Workbench::VERSION}"
		end

	end

end
