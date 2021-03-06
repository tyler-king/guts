class CreateGutsNavigations < ActiveRecord::Migration[4.2]
  def change
    create_table :guts_navigations do |t|
      t.string :title
      t.string :slug

      t.timestamps null: false
    end
    
    add_index :guts_navigations, :slug, unique: true
  end
end
