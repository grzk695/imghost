class Timestamps < ActiveRecord::Migration
  def change
  	change_column :users, :created_at, :datetime, :null => true, :default => nil
  	change_column :profiles, :created_at, :datetime, :null => true, :default => nil
  	change_column :photos, :created_at, :datetime, :null => true, :default => nil
  	change_column :albums, :created_at, :datetime, :null => true, :default => nil
  end
end
