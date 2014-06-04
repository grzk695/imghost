class AddProfileRefToPhotos < ActiveRecord::Migration
  def change
    add_reference :photos, :profile, index: true
  end
end
