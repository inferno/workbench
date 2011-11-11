module Haml

	module Helpers

		def render template
			dir = File.dirname $file
			template = template + '.haml'
			template_dir = File.dirname(template)
			basename = File.basename(template)
      Workbench::HamlRenderer.render File.join(dir, template_dir, "_#{basename}")
		end

	end
end
