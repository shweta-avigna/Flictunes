class Api::V1::FlictunesController < Api::V1::ApplicationController

	#for mock ups
	def create_flictune
		render :text => {:data =>  {      
        "status": "success",
        "message": "successfully created flictune",
        "Flictune_id": "1"  }
    }.to_json
	end

	def set_metadata
		render :text => {:data =>  {      
        "status": "success",
        "message": "Successfully updated the flictune",
        "Flictune_id": "1"  }
    }.to_json
	end

	def set_music
		render :text => {:data =>  {      
        "status": "success",
        "message": "Successfully added music to the flictune",
        "Flictune_id": "1"  }
    }.to_json
	end

	def show
		render :text => {:data =>  {      
        "status": "success",
        "Flictune": {"id": "1",
        "Photos": [{path: "https://path_to_s3_bucket_of_photo_fly_high",:order =>
			1,:name => "fly_high"} , {path: "https://path_to_s3_bucket_of_photo_world",:order=>2,:name => "world" }],      
         "Music": {path: "https://path_to_s3_bucket_of_audio_high_theme",:duration =>"1020",
         	:title => "high theme"},
         "Tag": "Chronological"},
        "Message": "successfully returned flic tune"}
    }.to_json
	end

	def meta
		render :text => {:data =>  {      
        "status": "success",
        "flictune": {
        	"id": "1",
        	"title": "My wonderful wedding",
        	"Tag": "Chronological"
        
        },
        
        "message": "Successfully returned meta data"  }
    }.to_json
	end

	def music
		render :text => {:data =>  {      
        "status": "success",
        "message": "Successfully returned flictune",
        "Flictune": {
        		"id": "1",
        		"Music": {path: "https://path_to_s3_bucket_of_audio_high_theme",:duration =>"1020",
         	:title => "high theme"}
        },
        "Message": "successfully returned music details"}
    }.to_json
	end


	def photos
		render :text => {:data =>  {      
        "status": "success",
        "message": "Successfully returned flictune photos",
        "flictune": {
        "id": "1",
        "Photos": [{path: "https://path_to_s3_bucket_of_photo_fly_high",:order =>
			1,:name => "fly_high"} , {path: "https://path_to_s3_bucket_of_photo_world",:order=>2,:name => "world" }]
        }
       }
    }.to_json
	end
end
