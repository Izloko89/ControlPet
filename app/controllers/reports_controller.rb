class ReportsController < ApplicationController
	def index
	end

	def show
    	set_item
  	end

	def search
		@sales = Sale.order('id ASC').where(:user_id => current_user.user_id).paginate(:page => params[:page], :per_page => 20).where(:created_at => params[:created_at,:last_date])
	end


private
 	
 	def set_item
      @item = Item.where(user_id => current_user.user_id)
      @categories = ItemCategory.where(:user_id => current_user.user_id)
    end
end
