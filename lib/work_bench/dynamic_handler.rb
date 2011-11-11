# encoding: utf-8
module Workbench

  # Класс для обработки запросов к нестатическим файлам
	class DynamicHandler

    # @param [String] path текущий каталог
    def initialize path
      @path = path
    end

    # Вызывается на каждый нестатический запрос
		def call(env)
			req = Rack::Request.new(env)
      filename = File.join(@path, 'haml', resolve_file(req.path))
      file_ext = File.extname(filename)
			if File.exists?(filename) && '.haml' != file_ext
				Rack::File.new(File.join(@path, 'haml')).call(env)
			else
				if File.exists? filename
					[ 200, {'Content-Type' => 'text/html'}, [Workbench::HamlRenderer.render(filename)] ]
				else
					[ 404, {'Content-Type' => 'text/html'}, ['File not found: '+req.path] ]
				end
			end
    end

    private

      # Переопределяет запрос
      #
      # @param [String] filename файл,который нужно переопределить
      def resolve_file filename
        filename = '/' == filename ? '/index.haml' : filename
        file_ext = File.extname(filename)
        if ['.html', '.htm', ''].include? file_ext
          filename = File.join(File.dirname(filename), File.basename(filename, file_ext) + '.haml')
        end unless File.exists? File.join(@path, 'haml', filename)
        filename
      end

	end

end
