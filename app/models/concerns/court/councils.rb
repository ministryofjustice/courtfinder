module Concerns
  module Court
    module Councils
      extend ActiveSupport::Concern

      included do
        attr_accessor :invalid_councils

        has_many :jurisdictions, through: :remits
        has_many :councils, through: :jurisdictions

        def area_councils_list(area_of_law = nil)
          relation = area_councils(area_of_law)
          relation.map(&:name).join(',')
        end

        def area_councils(area_of_law)
          councils.by_name.where remits: { area_of_law_id: area_of_law.id }
        end

        def set_area_councils_list(council_names_list, area_of_law)
          council_names = council_names_list.split(',')
          councils = Council.find_all_by_name council_names

          self.invalid_councils = council_names - councils.map(&:name)
          remits.find_or_create_by_area_of_law_id!(area_of_law.id).councils = councils
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
          attr_accessible :"#{method_name}_councils_list"
        end
      end

    end
  end
end
