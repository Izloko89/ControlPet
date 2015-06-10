class DeviseCreateUsers < ActiveRecord::Migration
  def migrate(direction)
    super
    # Create a default user
    User.create!(:email => 'admin@example.com', :username => 'gikmasoft', :password => 'g1km4s0ft', :password_confirmation => 'g1km4s0ft', :can_update_users => true, :can_update_items => true, :can_update_configuration => true, :can_view_reports => true, :can_update_sale_discount => true, :can_remove_sales => true, :user_id => 1) if direction == :up
  end

  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :username,           :null => false, :default => ""
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.integer  :user_id 
      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Permissions
      # possible abilities
      t.boolean :can_update_users, :default => false
      t.boolean :can_update_items, :default => true

      t.boolean :can_update_configuration, :default => false
      t.boolean :can_view_reports, :default => false

      t.boolean :can_update_sale_discount, :default => false
      t.boolean :can_remove_sales, :default => false
      t.boolean :is_admin, :default => false  

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :username,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end
end
