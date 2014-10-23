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

        def area_councils(area_of_law_name)
          area_of_law = AreaOfLaw.find_by_name! area_of_law_name
          councils.by_name.where court_council_links: { area_of_law_id: area_of_law.id }
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
          self.area_councils AreaOfLaw.children.name
        end

        def children_councils_list
          self.area_councils_list AreaOfLaw.children.name
        end

        def children_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw.children.name
        end

        def divorce_councils
          self.area_councils AreaOfLaw.divorce.name
        end
        
        def divorce_councils_list
          self.area_councils_list AreaOfLaw.divorce.name
        end

        def divorce_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw.divorce.name
        end

        def money_claims_councils
          self.area_councils AreaOfLaw.money_claims.name
        end

        def money_claims_councils_list
          self.area_councils_list AreaOfLaw.money_claims.name
        end

        def money_claims_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw.money_claims.name
        end

        def bankruptcy_councils
          self.area_councils AreaOfLaw.bankruptcy.name
        end

        def bankruptcy_councils_list
          self.area_councils_list AreaOfLaw.bankruptcy.name
        end

        def bankruptcy_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw.bankruptcy.name
        end

        def housing_possession_councils
          self.area_councils AreaOfLaw.housing_possession.name
        end

        def housing_possession_councils_list
          self.area_councils_list AreaOfLaw.housing_possession.name
        end

        def housing_possession_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw.housing_possession.name
        end

        def adoption_councils
          self.area_councils AreaOfLaw.adoption.name
        end


        def adoption_councils_list
          self.area_councils_list AreaOfLaw.adoption.name
        end

        def adoption_councils_list=(list)
          self.set_area_councils_list list, AreaOfLaw.adoption.name
        end
      end

    end
  end
end
