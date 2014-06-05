class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url , null: false , unique: true
      t.timestamps
    end

    add_index :links , :url , unique: true
  end
end
