class AddDeltaToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :delta, :boolean, :default => true,:null => false
    add_column :products, :delta, :boolean, :default => true,:null => false
    add_column :companies, :delta, :boolean, :default => true,:null => false
    add_index :topics, :delta
    add_index :products, :delta
    add_index :companies, :delta
  end
end
