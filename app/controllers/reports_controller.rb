class ReportsController < ApplicationController
	before_action :check_admin_user, only: [:show, :index]
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
 	
 	def check_admin_user
    unless current_user.is_admin || current_user.can_view_reports
      flash[:alert] = "No tienes los permisos"
      redirect_to :back
    end
    end
end
