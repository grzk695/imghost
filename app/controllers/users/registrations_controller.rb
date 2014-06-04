class Users::RegistrationsController < Devise::RegistrationsController
	
	def new
		@user = User.new
		@user.build_profile
	end

	private

		def sign_up_params
			params.require(:user).permit(
				:email,
				:password,
				:password_confirmation,
				:profile_attributes => [:id, :name, :user_id])
		end
end