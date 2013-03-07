class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string   "url"
      t.string   "image_src"
      t.string   "trackback"
      t.integer  "company_id"
      t.boolean  "fetched"
      t.binary   "price"
      t.binary     "meta"
      t.text     "description"
      t.timestamps
    end
  add_index "products", ["company_id"], :name => "imdex_company"
  add_index "products", ["trackback"], :name => "index_trackback"
  add_index "products", ["url"], :name => "index_products_on_url"
  end
end
