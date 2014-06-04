class AddViewsCount < ActiveRecord::Migration
  def change
  	add_column :photos , :views , :integer , default: 0
  	add_column :albums , :views , :integer , default: 0
  	add_column :photos , :public , :boolean , default: false
  	add_column :albums , :public , :boolean , default: false
  end
end
