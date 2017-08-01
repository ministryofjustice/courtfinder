class AddMagistrateCourtLocationCodeToCourts < ActiveRecord::Migration
  def change
    add_column :courts, :magistrate_court_location_code, :string
  end
end
