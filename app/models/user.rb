class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable


  validates :username, :presence => true, :uniqueness => true
  
  def self.reset_password_with
    1.hour
    # Determine the interval. Any time objects will do, say 1.hour
  end

end
