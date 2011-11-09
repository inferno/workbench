module Workbench

	class Exporter

		def initialize src, dest
			@src = src
			@dest = dest
			@browser = Rack::Test::Session.new(Rack::MockSession.new(Workbench::Application.new.app))
		end

		def process
			puts 'Export project'
			compile_sass
			copy_public_folder
			copy_views
		end

		private

			def log_action msg
				puts msg
			end

			def get_url path
				@browser.get path, {}, {'REQUEST_URI' => ['http://example.org', path].join('/')}
				response = @browser.last_response
				response.body
			end

			def compile_sass
				sass_files = get_file_list 'sass'
				sass_files.each do |file|
					ext = File.extname file
					path = "css/#{file.gsub(ext, '.css')}"
					body = get_url path
					File.open("#{@src}/public/#{path}", 'w+') { |f| f.puts body }
				end
			end

			def copy_public_folder
				FileUtils.mkdir(@dest) unless Dir.exist? @dest
				file_list = get_file_list 'public'
				file_list.each do |filename|
					dirname =  File.join(@dest, File.dirname(filename))
					FileUtils.mkdir_p(dirname) unless Dir.exist? dirname
					FileUtils.cp( File.join(@src, 'public', filename), File.join(@dest, filename))
					log_action "Copy #{filename}"
				end
			end

			def copy_views
				file_list = get_file_list 'haml'
				file_list.each do |filename|
					body = get_url filename
					filename = filename.gsub('.haml', '.html')
					dirname = File.dirname(File.join(@dest, filename))
					FileUtils.mkdir_p(dirname) unless Dir.exist? dirname
					File.open("#{@dest}/#{filename}", 'w+') { |f| f.puts body }
					log_action "Copy #{filename}"
				end
			end

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
