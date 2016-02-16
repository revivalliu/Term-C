class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sessions
  has_one :player
  
  # defined method koala which we will call from our controller. 
  # User.koala takes authentication credentials obtained 
  # using omniauth-facebook and then we use koala methods 
  # for fetching data from facebooks graph API.
  def self.koala(auth)
    access_token = auth['token']
    facebook = Koala::Facebook::API.new(access_token)
    facebook.get_object("me?fields=name,picture")
  end
end
