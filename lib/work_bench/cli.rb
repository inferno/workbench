module Workbench

	class Cli < Thor

		include Thor::Actions

		map '-T' => :help, 'h' => :help, 'i' => :init, 's' => :start, '-v' => :version

		def self.source_root
			File.join(File.dirname(__FILE__), '..', '..', 'template')
		end

		desc 'start [PATH] [--port] [--workers]', 'Start server in current directory'
		long_desc 'Start server in current directory'
		method_option :port, :aliases => '-p', :type => :numeric, :default => 4000, :desc => 'Port'
		method_option :workers, :aliases => '-w', :type => :numeric, :default => 4, :desc => 'Workers'
		def start path = '.'
      path = File.expand_path path
			puts 'Starting HTTP server...'
      app = Workbench::Application.new path
      app.start options[:port], options[:workers]
		end

		desc 'init [PATH] [--js=frameworks]', 'Initialize empty project in current directory'
		long_desc 'Initialize empty project in current directory'
		method_option :js, :type => :array, :default => ['jquery'], :desc => 'Install specific JS frameworks', :banner => 'jquery jquery-ui json'
		method_option :normalize, :type => :boolean, :default => true, :desc => 'Add _normalize.css (https://github.com/jonathantneal/normalize.css)'
		def init path = '.'
			puts 'Create empty project'

			self.destination_root = File.expand_path path

			empty_directory 'haml'
			empty_directory 'sass'
			empty_directory 'public/css'
			empty_directory 'public/js'
			empty_directory 'public/img'

			if options[:normalize]
				copy_file '_normalize.scss', 'sass/_normalize.scss'
			end

			unless options[:js].include? 'jquery'
				options[:js].push('jquery')
			end

			js_libs = Workbench::JSLibs.list
			options[:js].each do |js|
				if js_libs[js]
					get js_libs[js], "public/js/#{File.basename(js_libs[js])}"
				end
			end unless options[:js].empty?

			copy_file 'scripts.js', 'public/js/scripts.js'
			template 'style.sass', 'sass/style.sass'
			template 'index.haml', 'haml/index.haml'
			copy_file 'Gemfile', 'Gemfile'
		end

		desc 'js', 'Show available frameworks'
		def js
			js_libs = Workbench::JSLibs.list
      puts 'Available JS library'
      js_libs.each do |index, item|
        puts " * #{index} => #{item}"
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
