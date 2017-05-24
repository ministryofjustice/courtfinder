class TownDisambiguator
  attr_accessor :town
  delegate :id, to: :town

  def initialize(town)
    self.town = town
  end

  # Used in presenting the admin system court address form
  # to disambiguate the two Newports in the system, as this
  # was leading to the Isle of Wight Newport being associated
  # with the court in Newport Gwent.
  # See pivotal #83038366
  def unambiguous_name
    name = [town.name]
    if can_disambiguate? && town.duplicates.to_i > 0
      name << "(#{town.county_name})"
    end
    name.join(' ')
  end
  # use the unambiguous_name as the name method, for form fields
  alias name unambiguous_name

  def can_disambiguate?
    town.respond_to?(:duplicates) && town.respond_to?(:county_name)
  end
end
