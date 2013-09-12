class AddSlugsToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :slug, :string

    Region.find_each do |r|
      r.slug = nil
      r.save!
    end
  end
end
