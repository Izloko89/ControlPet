class DashboardController < ApplicationController
  def index
    @recent_sales = Sale.where(:user_id => current_user.user_id).order(:id).limit(10)
  	@popular_items = Item.where(:user_id => current_user.user_id).order(:id).limit(10)
  end

  def create_sale_with_product
		@sale = Sale.create
    @sale_by_vet = Sale.where(:user_id=>current_user.user_id).last
		item = Item.find(params[:item_id])
		LineItem.create(:item_id => params[:item_id].to_i, :quantity => params[:quantity].to_i, :price => item.price, :total_price => item.price * params[:quantity].to_i, :sale_id => @sale.id)
    
		price = (item.price * params[:quantity].to_i )

    @sale.tax = price * get_tax_rate
    @sale.amount = price
    @sale.total_amount = price + (price * get_tax_rate)
    @sale.user_id = current_user.user_id
    @sale.sale_by_vet = @sale_by_vet.sale_by_vet += 1 
    @sale.save

    redirect_to :controller => 'sales', :action => 'edit', :id => @sale.id
  end

	def get_tax_rate
    if @configurations.tax_rate.blank?
      return 0.00
    else
      return @configurations.tax_rate.to_f * 0.01
    end
  end
end
