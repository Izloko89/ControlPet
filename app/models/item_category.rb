class ItemCategory < ActiveRecord::Base
	has_many :items
	
	
	validates :name, :presence => {:message => "Nombre, No puede ir vacio"}
	validates_uniqueness_of :name, :scope => :user_id, :message => "Nombre, Está duplicado"


end
