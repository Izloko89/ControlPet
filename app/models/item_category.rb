class ItemCategory < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => true
	has_many :items

end
