class AddMoneyClaimsFlatToAreasOfLaw < ActiveRecord::Migration
  def change
    add_column :areas_of_law, :type_money_claims, :boolean, default: false
  end
end
