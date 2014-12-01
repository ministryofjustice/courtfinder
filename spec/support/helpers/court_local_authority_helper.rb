module CourtLocalAuthorityHelper
  def add_local_authorities_to_court(local_authorities:, court:, area_of_law:)
    court.remits.where(area_of_law_id: area_of_law.id).first_or_create.local_authorities << local_authorities
  end
end
