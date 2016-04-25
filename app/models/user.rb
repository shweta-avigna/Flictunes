class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         devise :omniauthable, :omniauth_providers => [:facebook]

     has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

   def self.from_omniauth(access_token)
   	# oauth_access_token=access_token.credentials.token
   	# @graph = Koala::Facebook::API.new(oauth_access_token)
   	# profile = @graph.get_object("me")
   	# @feed = @graph.get_connections("me", "feed")

    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
        user = User.create(name: data["name"],
           email: data["email"],
           password: Devise.friendly_token[0,20]
        )
    end
    user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end    
  end

end
