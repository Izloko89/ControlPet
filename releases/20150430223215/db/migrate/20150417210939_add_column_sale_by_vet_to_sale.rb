class AddColumnSaleByVetToSale < ActiveRecord::Migration
  def change
    add_column :sales, :sale_by_vet, :integer
  end
end
