module Workbench

	class Server

		def call(env)
			set_haml_options
			req = Rack::Request.new(env)
			path = '/' == req.path ? 'index.haml' : req.path
			[ 200, {'Content-Type' => 'text/html'}, [render_haml(path)] ]
		end

		def set_haml_options
			@options = {
				:escape_attrs => true,
				:attr_wrapper => '"',
				:format => :html4
			}
		end

		def render_haml path
			template = resolve_template(path)
			body = File.read(template)
			engine = Haml::Engine.new(body, @options)
			engine.render
		end


		def resolve_template path
			template = File.join($root, 'haml', path)
			unless File.exists?(template)
				template = File.join($root, 'haml', File.dirname(path), File.basename(path, File.extname(path)) + '.haml')
			end
			template
		end

	end
end
