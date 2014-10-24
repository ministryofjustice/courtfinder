class PopulateJurisdictionsFromCourtCouncilLinks < ActiveRecord::Migration
  def up
    Court.all.each do |court|
      court.remits.each do |remit|
        if (area_of_law = remit.area_of_law).present?
          remit.councils = court.councils.where court_council_links: { area_of_law_id: area_of_law.id }
        end
      end
    end
  end

  class Court < ActiveRecord::Base
    has_many :remits
    has_many :court_council_links
    has_many :councils, through: :court_council_links
  end

  class Remit < ActiveRecord::Base
    belongs_to :area_of_law
    has_many :jurisdictions
    has_many :councils, through: :jurisdictions
  end

  class AreaOfLaw < ActiveRecord::Base
  end

  class Jurisdiction < ActiveRecord::Base
    belongs_to :council
  end

  class Council < ActiveRecord::Base
    has_many :court_council_links
  end

  class CourtCouncilLink < ActiveRecord::Base
    belongs_to :council
  end
end
