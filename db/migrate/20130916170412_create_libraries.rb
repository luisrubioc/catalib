class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.integer :user_id
      t.string :title, :null => false
      t.integer :category_id
      t.string :description
      t.string :privacy

      t.timestamps
    end
    add_index :libraries, :user_id
  end
end
