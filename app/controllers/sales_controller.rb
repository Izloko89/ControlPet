class SalesController < ApplicationController
  before_action :set_configurations

  def index
    @sales = Sale.order('id ASC').where(:user_id => current_user.user_id).paginate(:page => params[:page], :per_page => 20)
  end
def show
redirect_to :back
end

  def new
    @sale_by_vet = Sale.where(:user_id=>current_user.user_id).last
    if @sale_by_vet.nil?
      @sale = Sale.create(:user_id=> current_user.user_id,:sale_by_vet => 1)
      redirect_to :controller => 'sales', :action => 'edit', :id => @sale.id
    else
      sale_by_vet = @sale_by_vet.sale_by_vet += 1 
      @sale = Sale.create(:user_id => current_user.user_id,:sale_by_vet => sale_by_vet)
      redirect_to :controller => 'sales', :action => 'edit', :id => @sale.id

    end
  end

  def edit
    user_id = Sale.find(params[:id])
    if user_id.user_id == current_user.user_id
      set_sale
    
      populate_items
      populate_customers

      @sale.line_items.build
      @sale.payments.build

      @custom_item = Item.new
      @custom_customer = Customer.new
    else
      redirect_to root_path, :alert => "Error, Venta no encontrada."
    end

  end

  def destroy
    set_sale

    if current_user.can_remove_sales == true
      @sale.destroy
      respond_to do |format|
      format.html { redirect_to sales_url, notice: 'La venta ha sido eliminada'}
      format.json { head :no_content }
    end
    else
      redirect_to @sale, alert: 'No tiene los permisos para eliminar'
    end
    
  end

  # searched Items
  def update_line_item_options
    set_sale
    populate_items

    if params[:search][:item_category].blank?
      @available_items = Item.where('name ILIKE ? AND published = true OR description ILIKE ? AND published = true OR sku ILIKE ? AND published = true', "%#{params[:search][:item_name]}%", "%#{params[:search][:item_name]}%", "%#{params[:search][:item_name]}%").where(:user_id => current_user.user_id).limit(5)
    elsif params[:search][:item_name].blank?
      @available_items = Item.where(:item_category_id => params[:search][:item_category]).where(:user_id => current_user.user_id).limit(5)
    else
      @available_items = Item.where('name ILIKE ? AND published = true AND item_category_id = ? OR description ILIKE ? AND published = true AND item_category_id = ? OR sku ILIKE ? AND published = true AND item_category_id = ?', "%#{params[:search][:item_name]}%", "#{params[:search][:item_category]}", "%#{params[:search][:item_name]}%", "#{params[:search][:item_category]}", "%#{params[:search][:item_name]}%", "#{params[:search][:item_category]}",).where(:user_id => current_user.user_id).limit(5)
    end

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def update_customer_options
    set_sale
    populate_items
    @available_customers = Customer.where('last_name ILIKE ? AND published = true OR first_name ILIKE ? AND published = true OR email_address ILIKE ? AND published = true OR phone_number ILIKE ? AND published = true', "%#{params[:search][:customer_name]}%","%#{params[:search][:customer_name]}%", "%#{params[:search][:customer_name]}%", "%#{params[:search][:customer_name]}%").where(:user_id => current_user.user_id).limit(5)
    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def create_customer_association
    set_sale

    unless @sale.blank? || params[:customer_id].blank?
      @sale.customer_id = params[:customer_id]
      @sale.save
    end


    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Add a searched Item
  def create_line_item
    set_sale
    populate_items

    existing_line_item = LineItem.where("item_id = ? AND sale_id = ?", params[:item_id], @sale.id).first
    
    if existing_line_item.blank?
      line_item = LineItem.new(:item_id => params[:item_id], :sale_id => params[:sale_id], :quantity => params[:quantity])
      line_item.price = line_item.item.price
      line_item.save

      remove_item_from_stock(params[:item_id], 1)
      update_line_item_totals(line_item)
    else
      existing_line_item.quantity += 1
      existing_line_item.save

      remove_item_from_stock(params[:item_id], 1)
      update_line_item_totals(existing_line_item)
    end

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end


  # Remove Item
  def remove_item
    set_sale
    populate_items

    line_item = LineItem.where(:sale_id => params[:sale_id], :item_id => params[:item_id]).first
    line_item.quantity -= 1
    if line_item.quantity <= 0
      line_item.destroy
    else
      line_item.save
      update_line_item_totals(line_item)
    end

    return_item_to_stock(params[:item_id], 1)

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Add one Item
  def add_item
    set_sale
    populate_items

    line_item = LineItem.where(:sale_id => params[:sale_id], :item_id => params[:item_id]).first
    line_item.quantity += 1
    line_item.save

    remove_item_from_stock(params[:item_id], 1)
    update_line_item_totals(line_item)

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def create_custom_item
    set_sale
    populate_items

    custom_item = Item.new
    custom_item.sku = "CI#{(rand(5..30) + rand(5..30)) * 11}_#{(rand(5..30) + rand(5..30)) * 11}"
    custom_item.name = params[:custom_item][:name]
    custom_item.description = params[:custom_item][:description]
    custom_item.price = params[:custom_item][:price]
    custom_item.stock_amount = params[:custom_item][:stock_amount]
    custom_item.item_category_id = params[:custom_item][:item_category_id]
    custom_item.user_id = current_user.user

    custom_item.save

    custom_line_item = LineItem.new(:item_id => custom_item.id, :sale_id => @sale.id, :quantity => custom_item.stock_amount, :price => custom_item.price )
    custom_line_item.total_price = custom_item.price * custom_item.stock_amount
    custom_line_item.save

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def create_custom_customer
    set_sale
    populate_items

    custom_customer = Customer.new
    custom_customer.first_name = params[:custom_customer][:first_name]
    custom_customer.last_name = params[:custom_customer][:last_name]
    custom_customer.email_address = params[:custom_customer][:email_address]
    custom_customer.phone_number = params[:custom_customer][:phone_number]
    custom_customer.address = params[:custom_customer][:address]
    custom_customer.city = params[:custom_customer][:city]
    custom_customer.state = params[:custom_customer][:state]
    custom_customer.zip = params[:custom_customer][:zip]
    custom_customer.user_id = current_user.user_id
    custom_customer.save

    @sale.add_customer(custom_customer.id)

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end


  # update Total For Line Items
  def update_line_item_totals(line_item)
    line_item.total_price = line_item.price * line_item.quantity
    line_item.save
  end


  def override_price
    @sale = Sale.find(params[:override_price][:sale_id])
    item = Item.where(:sku => params[:override_price][:line_item_sku] ).first
    line_item = LineItem.where(:sale_id => params[:override_price][:sale_id], :item_id => item.id).first
    line_item.price = params[:override_price][:price].gsub('$', '')
    line_item.save

    update_line_item_totals(line_item)
    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def sale_discount
    @sale = Sale.find_by_sale_by_vet(params[:sale_discount][:sale_id])

    @sale.discount = params[:sale_discount][:discount]
    @sale.save

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Destroy Line Item
  def destroy_line_item
    set_sale
    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Update Sale Totals
  def update_totals

    tax_amount = get_tax_rate

    set_sale

    @sale.amount = 0.00

    for line_item in @sale.line_items
      @sale.amount += line_item.total_price
    end

    @sale.tax = @sale.amount * tax_amount
    total_amount = @sale.amount + (@sale.amount * tax_amount)

    if @sale.discount.blank?
      @sale.total_amount = total_amount
    else
      discount_amount = total_amount * @sale.discount
      @sale.total_amount = total_amount - discount_amount
    end
    @sale.user_id = current_user.user_id
    @sale.save
  end

  def add_comment
    set_sale
    @sale.comments = params[:sale_comments][:comments]
    sale.user_id = current_user.user_id
    @sale.save

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  private

    def ajax_refresh
      return render(:file => 'sales/ajax_reload.js.erb')
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      if @sale.blank?
        if params[:sale_id].blank?
          if params[:search].blank?
            @sale = Sale.find(params[:id])
          else
            @sale = Sale.find(params[:search][:sale_id])
          end
        else 
          @sale = Sale.find(params[:sale_id])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:amount, :tax, :discount, :total_amount, :tax_paid, :amount_paid, :paid, :payment_type_id, :customer_id, :comments, :line_items_attributes, :items_attributes)
    end

    def populate_items
      @available_items = Item.where(:published => true, :user_id => current_user.user_id).limit(5)
    end

    def populate_customers
      @available_customers = Customer.where(:published => true, :user_id => current_user.user_id).limit(5)
    end

    def remove_item_from_stock(item_id, quantity)
      item = Item.find(item_id)
      item.stock_amount = item.stock_amount - quantity
      item.amount_sold += quantity
      item.save
    end

    def return_item_to_stock(item_id, quantity)
      item = Item.find(item_id)
      item.stock_amount = item.stock_amount + quantity
       item.amount_sold -= quantity
      item.save
    end

    def get_tax_rate
      if @configurations.tax_rate.blank?
        return 0.00
      else
        return @configurations.tax_rate.to_f * 0.01
      end
    end

end
