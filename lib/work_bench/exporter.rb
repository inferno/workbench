module Workbench

  # Export project to specific directory
	class Exporter

    # @param [String] src source directory
    # @param [String] dst destination directory
    # @param [Boolean] fix fix relative url
		def initialize src, dst, fix = false
			@fix = fix
			@src = src
			@dst = dst
			@browser = Rack::Test::Session.new(Rack::MockSession.new(Workbench::Application.new(src).app))
		end

    # Process export
		def process
			puts 'Exporting project'.color(:green)
			compile_sass
			copy_public_folder
			copy_views
		end

		private

      # Save file to filesystem
      #
      # @param [String] path path to file
      # @param [String] content file content
			def save_file path, content
				if @fix
					content = content.gsub "url('/", "url('"
					content = content.gsub 'src="/', 'src="'
					content = content.gsub 'href="/', 'href="'
				end
				File.open(path, 'w+') { |f| f.puts content }
			end

      # Log action to STDOUT
      #
      # @param msg [String] message
			def log_action msg
				puts '=> ' + msg
			end

      # Virtually get URL without starting server
      #
      # @param [String] path path to file
			def get_url path
				@browser.get path, {}, {'REQUEST_URI' => ['http://example.org', path].join('/')}
				response = @browser.last_response
				response.body
			end

      # Compile SASS directory
			def compile_sass
				sass_files = get_file_list 'sass'
				sass_files.each do |file|
					ext = File.extname file
					path = "css/#{file.gsub(ext, '.css')}"
					body = get_url path
					save_file "#{@src}/public/#{path}", body
				end
			end

      # Export Public folder content
			def copy_public_folder
				FileUtils.mkdir(@dst) unless Dir.exist? @dst
				file_list = get_file_list 'public'
				file_list.each do |filename|
					dirname =  File.join(@dst, File.dirname(filename))
					FileUtils.mkdir_p(dirname) unless Dir.exist? dirname
					FileUtils.cp( File.join(@src, 'public', filename), File.join(@dst, filename))
					log_action "Copy #{filename.color(:blue)}"
				end
			end

      # Parse views and compile to export folder
			def copy_views
				file_list = get_file_list 'haml'
				file_list.each do |filename|
					body = get_url filename
					filename = filename.gsub('.haml', '.html')
					dirname = File.dirname(File.join(@dst, filename))
					FileUtils.mkdir_p(dirname) unless Dir.exist? dirname
					save_file "#{@dst}/#{filename}", body
					log_action "Copy #{filename.color(:blue)}"
				end
			end

      # Recursively get file list
      #
      # @param [String] relative_path path to directory
      # @return [Array] file list
			def get_file_list relative_path
				path = File.join(@src, relative_path)
				result = nil
				FileUtils.cd(path) do
					result = Dir.glob("**/*", File::FNM_DOTMATCH)
					result.reject! { |fn| File.directory?(fn) }
					result.reject! { |fn| fn =~ /(^_|\/_)/ }
				end
				result
			end

	end

end
