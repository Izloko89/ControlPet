class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.string :sku
    	t.string :name
    	t.text :description
    	t.decimal :price, :precision => 8, :scale => 2
    	t.integer :stock_amount
      t.integer :amount_sold, :default => 0
      t.decimal :cost_price, :precision => 8, :scale => 2
      t.boolean :published, :default => true

      t.timestamps
    end
  end
end
