class UpdateMoneyClaimsContactTypes < ActiveRecord::Migration
  def up
    if (money_claims = ContactType.find_by_name('Money claims')).present?
      money_claims.name = 'County Court Money Claims Centre'
      money_claims.save!
    end

    ContactType.where(name: 'Local money claims enquiries').first_or_create!
  end
end
