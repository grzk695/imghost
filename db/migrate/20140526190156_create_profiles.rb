class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.timestamps
    end

    add_column :profiles, :user_id, :integer
  	add_column :profiles, :name, :string
  	add_index :profiles, :name, unique: true
  	add_index :profiles, :user_id
  end
end
