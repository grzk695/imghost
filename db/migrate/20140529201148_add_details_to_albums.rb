class AddDetailsToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :name, :string, null: false
    add_column :albums, :description, :string
    add_column :albums, :profile_id, :integer, null: false
    add_index :albums, :name
    add_index :albums, [:profile_id,:name], unique: true
    add_column :photos, :album_id, :integer
    add_index :photos, :album_id
  end
end
