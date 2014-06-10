class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.string :text
      t.string :url
      t.boolean :always_visible, :default => false

      t.timestamps
    end

    create_table :court_types_external_links, id: false do |t|
      t.belongs_to :court_type
      t.belongs_to :external_link
    end

    create_table :areas_of_law_external_links, id: false do |t|
      t.belongs_to :area_of_law
      t.belongs_to :external_link
    end

  end
end
