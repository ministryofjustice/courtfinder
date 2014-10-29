module Concerns
  module Court
    module Councils
      extend ActiveSupport::Concern

      included do
        attr_accessor :invalid_councils

        has_many :jurisdictions, through: :remits
        has_many :local_authorities, through: :jurisdictions

        def area_councils_list(area_of_law = nil)
          relation = area_councils(area_of_law)
          relation.map(&:name).join(',')
        end

        def area_councils(area_of_law)
          local_authorities.by_name.where remits: { area_of_law_id: area_of_law.id }
        end

        def set_area_councils_list(council_names_list, area_of_law)
          council_names = council_names_list.split(',')
          councils = LocalAuthority.find_all_by_name council_names

          self.invalid_councils = council_names - councils.map(&:name)
          remits.find_or_create_by_area_of_law_id!(area_of_law.id).local_authorities = councils
        end

        def single_point_of_entry_for?(area_of_law)
          remit = remits.find_by_area_of_law_id(area_of_law.id)
          remit.present? && remit.single_point_of_entry?
        end

        def set_single_point_of_entry_for(area_of_law, value)
          remit = remits.find_or_create_by_area_of_law_id!(area_of_law.id)
          remit.single_point_of_entry = value
          remit.save!
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

          define_method :"#{method_name}_single_point_of_entry" do
            single_point_of_entry_for? AreaOfLaw.send(method_name)
          end

          define_method :"#{method_name}_single_point_of_entry=" do |value|
            set_single_point_of_entry_for AreaOfLaw.send(method_name), value
          end
          attr_accessible :"#{method_name}_single_point_of_entry"
        end
      end

    end
  end
end
