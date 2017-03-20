class AddImageFileUrlToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :image_file_path, :string
  end
end
