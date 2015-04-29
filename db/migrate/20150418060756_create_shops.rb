class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name
      t.string :coordinate
      t.string :image_url
      t.string :display_phone
      t.string :location_display_address
      t.string :rating_image_small_url
      t.integer :review_count

      t.timestamps
    end
  end
end
