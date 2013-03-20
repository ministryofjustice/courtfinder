class AddImageToCourt < ActiveRecord::Migration
  def change
    add_column :courts, :old_image_id, :integer
    add_column :courts, :image, :string
    add_column :courts, :image_description, :string
    add_column :facilities, :image_description, :string
    change_column :court_facilities, :description, :text
  end
end
