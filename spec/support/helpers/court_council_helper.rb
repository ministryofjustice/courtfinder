module CourtCouncilHelper
  def add_councils_to_court(councils:, court:, area_of_law:)
    CourtCouncilLink.with_scope(create: { area_of_law: area_of_law }) do
      court.councils << councils
    end
  end
end
