class CreateGutsCategorizations < ActiveRecord::Migration[4.2]
  def change
    create_table :guts_categorizations do |t|
      t.integer :category_id
      t.integer :content_id

      t.timestamps null: false
    end
  end
end
