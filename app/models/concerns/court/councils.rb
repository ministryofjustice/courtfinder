module Concerns
  module Court
    module Councils
      extend ActiveSupport::Concern

      included do
        attr_accessor :invalid_councils
        attr_accessible :children_councils_list, :divorce_councils_list, :adoption_councils_list, :money_claims_councils_list, :bankruptcy_councils_list, :housing_possession_councils_list

        has_many :court_council_links
        has_many :councils, through: :court_council_links
        
        def area_councils_list(area_of_law = nil)
          relation = area_councils(area_of_law)
          relation.map(&:name).join(',')
        end

        def area_councils(area_of_law)
          area_of_law_id = AreaOfLaw.where(name: area_of_law).first.id

          relation = court_council_links.by_name
          relation = relation.where(area_of_law_id: area_of_law_id)
          relation.map(&:council).compact
        end

        def set_area_councils_list(council_names_list, area_of_law_name)
          council_names = council_names_list.split(',')
          councils = Council.find_all_by_name council_names
          area_of_law = AreaOfLaw.find_by_name! area_of_law_name

          self.invalid_councils = council_names - councils.map(&:name)
          CourtCouncilLink.with_scope(create: { area_of_law: area_of_law }) do
            self.councils = councils
          end
        end

        def children_councils
          self.area_councils AreaOfLaw::Name::CHILDREN
        end

        def children_councils_list
          self.area_councils_list AreaOfLaw::Name::CHILDREN
        end

        def children_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw::Name::CHILDREN
        end

        def divorce_councils
          self.area_councils AreaOfLaw::Name::DIVORCE
        end
        
        def divorce_councils_list
          self.area_councils_list AreaOfLaw::Name::DIVORCE
        end

        def divorce_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw::Name::DIVORCE
        end

        def money_claims_councils
          self.area_councils AreaOfLaw::Name::MONEY_CLAIMS
        end

        def money_claims_councils_list
          self.area_councils_list AreaOfLaw::Name::MONEY_CLAIMS
        end

        def money_claims_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw::Name::MONEY_CLAIMS
        end

        def bankruptcy_councils
          self.area_councils AreaOfLaw::Name::BANKRUPTCY
        end

        def bankruptcy_councils_list
          self.area_councils_list AreaOfLaw::Name::BANKRUPTCY
        end

        def bankruptcy_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw::Name::BANKRUPTCY
        end

        def housing_possession_councils
          self.area_councils AreaOfLaw::Name::HOUSING_POSSESSION
        end

        def housing_possession_councils_list
          self.area_councils_list AreaOfLaw::Name::HOUSING_POSSESSION
        end

        def housing_possession_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw::Name::HOUSING_POSSESSION
        end

        def adoption_councils
          self.area_councils AreaOfLaw::Name::ADOPTION
        end


        def adoption_councils_list
          self.area_councils_list AreaOfLaw::Name::ADOPTION
        end

        def adoption_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw::Name::ADOPTION
        end
      end

    end
  end
end
