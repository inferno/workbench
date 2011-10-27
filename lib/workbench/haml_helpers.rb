module Haml
	module Helpers

		def img src, alt = ""
			width, height = FastImage.size(src)
			'<img src="'+src+'" width="'+(width.to_s)+'" height="'+(height.to_s)+'" alt="'+alt+'">'
		end

	end
end
