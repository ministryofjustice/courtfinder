class AddSlugToCourtTypes < ActiveRecord::Migration
  def change
    add_column :court_types, :slug, :string
  end
end
