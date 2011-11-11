module Workbench

  # CLI application for Workbench
	class Cli < Thor

		include Thor::Actions

		map '-T' => :help, 'h' => :help, 'i' => :init, 's' => :start, '-v' => :version

		def self.source_root
			File.join(File.dirname(__FILE__), '..', '..', 'template')
		end

    # Start Unicorn server
    #
    # @param [String] path path to project directory
    #
    # @example
    #  workbench start
    #
    # @example
    #  workbench start project/
    #
		desc 'start [PATH] [--port] [--workers]', 'Start server in current directory'
		long_desc 'Start server in current directory'
		method_option :port, :aliases => '-p', :type => :numeric, :default => 4000, :desc => 'Port'
		method_option :workers, :aliases => '-w', :type => :numeric, :default => 4, :desc => 'Workers'
		def start path = '.'
      path = File.expand_path path
			puts 'Starting HTTP server...'.color(:green)
      app = Workbench::Application.new path
      app.start options[:port], options[:workers]
		end

    # Create empty project from template in current directory or specific path
    #
    # @param [String] path path to new project directory
    #
    # @example
    #  workbench init
    #
    # @example
    #  workbench init project/
    #
		desc 'init [PATH] [--js=frameworks]', 'Initialize empty project'
		long_desc 'Initialize empty project'
		method_option :js, :type => :array, :default => ['jquery'], :desc => 'Install specific JS frameworks', :banner => 'jquery jquery-ui json'
		method_option :normalize, :type => :boolean, :default => true, :desc => 'Add _normalize.css (https://github.com/jonathantneal/normalize.css)'
		def init path = '.'
			puts 'Create empty project'.color(:green)

			self.destination_root = File.expand_path path

			empty_directory 'haml'
			empty_directory 'sass'
			empty_directory 'public/css'
			empty_directory 'public/js'
			empty_directory 'public/img'

			if options[:normalize]
				copy_file '_normalize.scss', 'sass/_normalize.scss'
			end

			if options[:js] && !options[:js].empty?
        js_libs = Workbench::JSLibs::LIST
        options[:js].each do |js|
          if js_libs[js]
            get js_libs[js], "public/js/#{File.basename(js_libs[js])}"
          end
        end
      end

			copy_file 'scripts.js', 'public/js/scripts.js'
			template 'style.sass', 'sass/style.sass'
			template 'index.haml', 'haml/index.haml'
			copy_file 'Gemfile', 'Gemfile'
		end

    # Export project to specific directory
    #
    # @param [String] path export directory
		desc 'export [PATH] [--fix-urls]', 'Export project'
		method_option :fix_urls, :type => :boolean, :default => true, :desc => 'Fix relative server urls'
		def export path = 'export'
  		export = Workbench::Exporter.new File.expand_path('.'), File.join(File.expand_path('.'), path), options[:fix_urls]
			export.process
		end

    # Get available JS frameworks
    #
    # @example
    #  workbench js
    #
    desc 'js', 'Show available JS frameworks'
    def js
      puts 'Available JS frameworks'.color(:green)
      Workbench::JSLibs::LIST.each { |index, item| puts " * #{index.color(:blue)} => #{item}" }
    end

    # Get version number
    #
    # @example
    #  workbench version
    #
		desc 'version', 'Show gem version'
		def version
			puts "Version: #{Workbench::VERSION.color(:blue)}"
		end

	end

end
