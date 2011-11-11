module Workbench

	class Server

    def initialize path
      @path = path
    end

		def call(env)
			req = Rack::Request.new(env)
			file = File.join(@path, 'haml', '/' == req.path ? 'index.haml' : req.path)
			ext = File.extname(file)
			if ext.empty?
				file = file + '.haml'
				ext = '.haml'
			end
			if File.exists?(file) && '.haml' != ext
				Rack::File.new(File.join($root, 'haml')).call(env)
			else
				if File.exists? file
					[ 200, {'Content-Type' => 'text/html'}, [Workbench::HamlRenderer.render(file)] ]
				else
					[ 404, {'Content-Type' => 'text/html'}, ['File not found: '+req.path] ]
				end
			end
		end

	end

end
