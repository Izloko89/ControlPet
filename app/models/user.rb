class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable


  validates :username, :presence => {:message => "Nombre de usuario, no puede ir vacio"}
  validates_uniqueness_of :username, :scope => :user_id, :message => "El usuario esta repetido"
  validates_uniqueness_of :email, :message => "El correo ya existe"
end
