class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string   "name"
      t.string   "slug"
      t.string :country,:state,:city
      t.string   "address"
      t.string   "opera_address"
      t.string   "zip"
      t.string   "phone"
      t.string   "mobile"
      t.string   "fax"
      t.string   "website"
      t.string   "aliexpress"
      t.string   "email"
      t.string   "btypes"
      t.string   :main_products
      t.string   "contact"
      t.string   "trackback"
      t.boolean  "fetched"
      t.binary     "meta"
      t.text     "description"

      t.timestamps
    end
    add_index "companies", ["slug"], :name => "index_companies_on_slug"
    add_index "companies", ["trackback"], :name => "index_trackback"
  end
end
