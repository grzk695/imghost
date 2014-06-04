module ApplicationHelper
	def check_signed_in
		unless user_signed_in?
			redirect_to login_url, warning: "Please sing in."
		end
	end

	def current_profile_name
		if user_signed_in?
			current_user.profile.name;
		end
	end

	def profile_owner_name? name
		if user_signed_in? && current_profile_name==name
			return true
		else
			return false
		end
	end

	def owner_signin? subject
		if user_signed_in? && subject.profile == current_user.profile
			return true
		else
			return false
		end
	end
end
