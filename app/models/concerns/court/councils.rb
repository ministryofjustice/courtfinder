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
          councils.by_name.where court_council_links: { area_of_law_id: area_of_law.id }
        end

        def set_area_councils_list(council_names_list, area_of_law)
          council_names = council_names_list.split(',')
          councils = Council.find_all_by_name council_names

          self.invalid_councils = council_names - councils.map(&:name)
          CourtCouncilLink.with_scope(create: { area_of_law: area_of_law }) do
            self.councils = councils
          end
        end

        %i(children divorce money_claims bankruptcy housing_possession adoption).each do |method_name|
          define_method :"#{method_name}_councils" do
            area_councils AreaOfLaw.send(method_name)
          end

          define_method :"#{method_name}_councils_list" do
            area_councils_list AreaOfLaw.send(method_name)
          end

          define_method :"#{method_name}_councils_list=" do |council_names_list|
            set_area_councils_list council_names_list, AreaOfLaw.send(method_name)
          end
        end
      end

    end
  end
end
