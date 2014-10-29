module CourtCouncilHelper
  def add_councils_to_court(councils:, court:, area_of_law:)
    court.remits.find_or_create_by_area_of_law_id!(area_of_law.id).local_authorities << councils
  end
end
