class ReportsController < ApplicationController
	def index
   
	end

	def show
    	
  	end

	def search
    start_date = params[:search][:start_date]
    end_date = params[:search][:end_date]
    @sales = Sale.where(:created_at => start_date..end_date).where(:user_id => current_user.user_id).paginate(:page => params[:page], :per_page => 5)
    
 	end
  	

 def ajax_refresh
      return render(:file => 'reports/search.js.erb')
    end

private
 	
 	def set_item
      
    end
end
