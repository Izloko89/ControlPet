class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
    	t.integer :item_id
      t.integer :quantity, :default => 1
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :total_price, :precision => 8, :scale => 2
      t.integer :sale_id

      t.timestamps
    end
  end
end
