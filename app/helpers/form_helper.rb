module FormHelper

	def setup_user(user)
		user.profile ||= Profile.new()
		user
	end

end