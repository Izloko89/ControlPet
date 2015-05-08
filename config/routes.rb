Rails.application.routes.draw do

  resources :item_categories

  resources :reports do
    collection do
      get 'total_report'
      get 'date_range_report'
      get 'customer_report'
      get 'item_report'
    end
  end

  resources :line_items

  resources :payments do
    collection do
      get 'make_payment'
    end
  end

  resources :configurations do 
    collection do 
      get 'update'
    end
  end

  resources :customers

  resources :items do
    get 'search'
    collection do
      get 'search'
    end
  end

resources :sales do
    collection do
      get 'update_line_item_options'
      get 'update_customer_options'
      get 'create_line_item'
      get 'update_totals'
      get 'add_item'
      get 'remove_item'
      get 'create_customer_association'
      get 'create_custom_item'
      get 'create_custom_customer'
      get 'add_comment'
      post 'override_price'
      post 'sale_discount'
    end
  end


  resources :dashboard do
    collection do
      get 'create_sale_with_product'
    end
  end

  devise_for :users
  resources :users do
    collection do
      post 'new_user'
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboard#index'
end
