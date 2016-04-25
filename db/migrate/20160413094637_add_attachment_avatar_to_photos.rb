class AddAttachmentAvatarToPhotos < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :photos, :avatar
  end
end
