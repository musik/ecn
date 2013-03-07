class CreateKvs < ActiveRecord::Migration
  def change
    create_table :kvs do |t|
      t.string :k
      t.string :v
    end
    add_index :kvs,:k,:uniq=>true
  end
end
