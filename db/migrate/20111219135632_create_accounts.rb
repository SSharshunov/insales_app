class CreateAccounts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :accounts do |t|
      t.text    :insales_subdomain,   :null => false
      t.text    :password,            :null => false
      t.integer :insales_id,          :null => false
      t.integer :delivery_id,         :null => false
      t.integer :store_city_id,       :null => false
      t.text    :pricing_policy,      :null => false
      t.timestamps
    end
    add_index :accounts, [:insales_subdomain], :unique => true
  end

  def self.down
    drop_table :accounts
  end
end
