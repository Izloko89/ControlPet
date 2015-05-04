class AddUserIdToItemCategories < ActiveRecord::Migration
  def change
    add_column :item_categories, :user_id, :integer
  end
end
