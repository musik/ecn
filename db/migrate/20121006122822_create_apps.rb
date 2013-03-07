class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :domain
      t.string :name

      t.timestamps
    end
    add_column :topics,:app_id,:integer
    add_index :topics,:app_id

    add_column :companies,:app_id,:integer
    add_index :companies,:app_id
    add_column :products,:app_id,:integer
    add_index :products,:app_id
  end
end
