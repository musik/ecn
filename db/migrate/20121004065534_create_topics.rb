class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.string :slug
      t.integer :products_count,:default=>0


      t.timestamps
    end
    add_index :topics,:name,:uniq=>true
    add_index :topics,:slug,:uniq=>true
    add_index :topics,:products_count
  end
end
