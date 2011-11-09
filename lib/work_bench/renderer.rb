module Workbench

	class Renderer

		def initialize file, options = {}
			@file = file
			@options = {
				:escape_attrs => true,
				:attr_wrapper => '"',
				:format => :html4
			}.merge(options)

		end

		def render
			engine = Haml::Engine.new(File.read(@file), @options)
			engine.render
		end

	end

end
