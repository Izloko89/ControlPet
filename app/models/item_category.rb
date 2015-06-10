class ItemCategory < ActiveRecord::Base
	has_many :items
	
	validates :user_id, presence: true
	validates :name, :presence => true
end
