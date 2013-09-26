class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :library_id
      t.string :title, :null => false
      t.integer :rating
      t.string :status
      t.string :lent
      t.string :notes

      t.timestamps
    end
  end
end
