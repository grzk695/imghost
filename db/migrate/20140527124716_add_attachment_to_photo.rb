class AddAttachmentToPhoto < ActiveRecord::Migration
   def self.up
    add_attachment :photos, :photo
  end

  def self.down
    remove_attachment :photos, :photo
  end
end
