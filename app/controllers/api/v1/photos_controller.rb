class Api::V1::PhotosController < Api::V1::ApplicationController
	def new
		@photo = Photo.new
	end
	def create
		@photo = Photo.create( photo_params )
		redirect_to photo_path(@photo)
	end

	def index
		@photos = Photo.all
	end

	def show
		@photo = Photo.find(params[:id])
		@url = @photo.avatar.expiring_url(10)
	end
	def photo_params
	  params.require(:photo).permit(:avatar)
	end
end
