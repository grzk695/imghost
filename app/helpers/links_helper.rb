module LinksHelper
	def full_url url
		return "#{request.protocol}#{request.host_with_port}#{url}"
	end
end
