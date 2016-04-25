class Api::V1::UsersController < Api::V1::ApplicationController
	def edit
		@user = User.find(params[:id])
	end

	def show
		@user = User.find(params[:id])
	end
end
