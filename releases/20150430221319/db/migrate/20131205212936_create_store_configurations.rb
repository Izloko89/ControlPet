class CreateStoreConfigurations < ActiveRecord::Migration
  def change
    create_table :store_configurations do |t|
    	t.string :store_name
    	t.text :store_description
    	t.string :email_address
    	t.string :phone_number
    	t.string :website_url
    	t.string :address
    	t.string :city
    	t.string :state
    	t.string :zip

    	t.integer :currency
    	t.decimal :tax_rate, :precision => 8, :scale => 2

      t.timestamps
    end

    StoreConfiguration.create()
  end
end
