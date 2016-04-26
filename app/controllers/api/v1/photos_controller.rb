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


	#for mock ups

	def add_photo
		render :text => {:data =>  {      
        "status": "success",
        "message": "successfully added photo"}
    }.to_json
	end

	def photo_order
		render :text => {:data =>  {      
        "status": "success",
        "message": "successfully saved order of photos"}
    }.to_json
	end

	def destroy
		render :text => {:data =>  {      
        "status": "success",
        "message": "successfully reoved the photo"}
    }.to_json
	end


end
