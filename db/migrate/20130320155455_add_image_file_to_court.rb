class AddImageFileToCourt < ActiveRecord::Migration
  def change
    add_column :courts, :image_file, :string
  end
end
