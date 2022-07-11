class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :ean
      t.float :weight
      t.float :volume
      t.string :url
      t.string :image_url
      t.integer :category_id

      t.timestamps
    end
  end
end
