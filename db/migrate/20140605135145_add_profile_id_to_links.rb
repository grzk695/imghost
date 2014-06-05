class AddProfileIdToLinks < ActiveRecord::Migration
  def change
  	add_column :links , :profile_id , :integer
  end
end
