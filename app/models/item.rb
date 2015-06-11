class Item < ActiveRecord::Base
	has_many :line_items
	belongs_to :item_category

	validates :sku, :presence => {:message => "Sku, No puede ir vacio"}
	validates_uniqueness_of :sku, :scope => :user_id, :message => "SKU, Está duplicado"
	validates :name, :presence => {:message => "Nombre, No puede ir vacio"}
	validates_uniqueness_of :name, :scope => :user_id, :message => "Nombre, Está duplicado"
	validates :price, :presence => {:message => "Precio, No puede ir vacio"}
	validates :stock_amount, :presence => {:message => "El inventario, No puede ir vacio"}
	validates :item_category_id, :presence => {:message => "Por favor, Seleccione una categoría"}
end
