class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 20).where(:published => true, :user_id => current_user.user_id)
  end

  # GET /items/1
  # GET /items/1.json
  def show
    set_item
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    set_item
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    @item.published = true
    @item.user_id = current_user.user_id
    search = Item.where(:sku => @item.sku,:user_id => current_user.user_id)
    
    if search.blank?
      respond_to do |format|
        if @item_category.save
          format.html { redirect_to :back, notice: 'Se ha creado el articulo' }
          format.json { render action: 'show', status: :created, location: @item_category }    
        else
          format.html { render action: 'new' }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    else
        respond_to do |duplicate|
        duplicate.html { redirect_to @item, alert: 'SKU Repetido' }
        duplicate.json { render json: @item, status: :unprocessable_entity}
  end
end
end
  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    search = Item.where(:sku => item_params[:sku],:user_id => current_user.user_id)
    if search.blank?
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Se ha actualizado el articulo' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  else
    respond_to do |duplicate|
        duplicate.html { redirect_to @item, alert: 'SKU Repetido' }
        duplicate.json { render json: @item, status: :unprocessable_entity}
    end
  end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.published = false
    @item.save

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end

  def search
    # @items =  Item.where(["name LIKE :tag", {:tag => params[:search][:item_name]}])
    @items =  Item.find(:all, :conditions => ['name LIKE ?', "%#{params[:search][:item_name]}%"])
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
      @categories = ItemCategory.where(:user_id => current_user.user_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:image_url, :sku, :name, :description, :price, :stock_amount, :cost_price, :item_category_id, :published)
    end
end
