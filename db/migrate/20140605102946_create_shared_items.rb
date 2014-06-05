class CreateSharedItems < ActiveRecord::Migration
  def change
    create_table :shared_items do |t|
      t.references :link , null: false
      t.references :item , polymorphic: true , null: false
      t.timestamps
    end

    add_index :shared_items , [:item_id , :item_type ]
  end
end
