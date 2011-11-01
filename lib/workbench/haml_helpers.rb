module Haml
	module Helpers

		def img src, alt = ""
			width, height = FastImage.size(src)
			'<img src="'+src+'" width="'+(width.to_s)+'" height="'+(height.to_s)+'" alt="'+alt+'">'
		end

		def render template
			dir = File.dirname $file
			template = template + '.haml'
			template_dir = File.dirname(template)
			basename = File.basename(template)
			Workbench::Renderer.new(File.join(dir, template_dir, "_#{basename}")).render
		end

	end
end
