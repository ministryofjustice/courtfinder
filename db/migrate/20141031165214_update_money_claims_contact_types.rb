class UpdateMoneyClaimsContactTypes < ActiveRecord::Migration
  def up
    if (money_claims = ContactType.find_by_name('Money claims')).present?
      money_claims.name = 'County Court Money Claims Centre'
      money_claims.save!
    end

    ContactType.find_or_create_by_name 'Local money claims enquiries'
  end
end
