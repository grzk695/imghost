class AddTitleDescriptionColumnsToPhotos < ActiveRecord::Migration
  def change
  	add_column :photos, :title, :string
  	add_column :photos, :description, :string
  end
end
