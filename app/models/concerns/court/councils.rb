module Concerns
  module Court
    module Councils
      extend ActiveSupport::Concern

      included do
        attr_accessible :children_councils_list, :divorce_councils_list, :adoption_councils_list

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
          relation.map(&:council)
        end

        def set_area_councils_list(list, area_of_law = nil)
          area_of_law_id = AreaOfLaw.where(name: area_of_law).first.id
          names = list.split(',').compact

          # map existing councils
          exisiting_council_ids = court_council_links.where(area_of_law_id: area_of_law_id).map(&:council_id)
          new_council_ids = names.map{|name| Council.where(name: name).first.try(:id) }.compact
          
          # delete old records removed from list 
          exisiting_council_ids.each do |id|
            court_council_links.where(council_id: id, area_of_law_id: area_of_law_id).first.delete unless new_council_ids.include?(id)
          end

          # add new records included in list
          new_council_ids.each do |id|
            court_council_links.create!(council_id: id, area_of_law_id: area_of_law_id) unless exisiting_council_ids.include?(id)
          end
        end

        def children_councils
          self.area_councils 'Children'
        end

        def children_councils_list
          self.area_councils_list 'Children'
        end

        def children_councils_list=(list)
          self.set_area_councils_list list, 'Children'
        end

        def divorce_councils
          self.area_councils 'Divorce'
        end
        
        def divorce_councils_list
          self.area_councils_list 'Divorce'
        end

        def divorce_councils_list=(list)
          self.set_area_councils_list list, 'Divorce'
        end

        def adoption_councils
          self.area_councils 'Adoption'
        end

        def adoption_councils_list
          self.area_councils_list 'Adoption'
        end

        def adoption_councils_list=(list)
          self.set_area_councils_list list, 'Adoption'
        end
      end

    end
  end
end