class AddColumnUserIdToStoreConfiguration < ActiveRecord::Migration
  def change
    add_column :store_configurations, :user_id, :integer
  end
end
