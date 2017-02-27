class AddImageFileToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :image_file, :string
  end
end
