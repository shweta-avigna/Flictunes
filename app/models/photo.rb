class Photo < ActiveRecord::Base
	has_attached_file :avatar, :styles => {medium: "200x200>", thumb: "100x100>"},
:path => "/phot/:style/:basename.:extension/#{Time.now.to_i}",
:url => ':s3_domain_url',
:storage => :s3,
:s3_permissions => 'authenticated-read',
:s3_credentials => "#{Rails.root.to_path}/config/initializers/aws.yml"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/


end
