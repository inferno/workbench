module Haml

	module Helpers

		def render template
			dir = File.dirname $file
			template = template + '.haml'
			template_dir = File.dirname(template)
			basename = File.basename(template)
			Workbench::Renderer.new(File.join(dir, template_dir, "_#{basename}")).render
		end

	end
end
