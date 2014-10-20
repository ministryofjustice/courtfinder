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

        def set_area_councils_list(list, area_of_law = nil)
          area_of_law_id = AreaOfLaw.where(name: area_of_law).first.id
          names = list.split(',').compact

          # map existing councils
          existing_council_ids = court_council_links.where(area_of_law_id: area_of_law_id).map(&:council_id)
          self.invalid_councils = []
          new_council_ids = names.map{|name| Council.where(name: name).first.try(:id) || self.invalid_councils << name }.compact
          
          # delete old records removed from list 
          existing_council_ids.each do |id|
            court_council_links.where(council_id: id, area_of_law_id: area_of_law_id).first.delete unless new_council_ids.include?(id)
          end

          # add new records included in list
          new_council_ids.each do |id|
            court_council_links.create!(council_id: id, area_of_law_id: area_of_law_id) unless existing_council_ids.include?(id)
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
