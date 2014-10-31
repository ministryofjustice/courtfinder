module CourtLocalAuthorityHelper
  def add_local_authorities_to_court(local_authorities:, court:, area_of_law:)
    court.remits.find_or_create_by_area_of_law_id!(area_of_law.id).local_authorities << local_authorities
  end
end
