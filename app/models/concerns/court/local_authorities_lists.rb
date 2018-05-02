module Concerns
  module Court
    module LocalAuthoritiesLists
      extend ActiveSupport::Concern

      included do
        [:children, :divorce, :adoption, :civil_partnership].each do |method_name|
          define_method :"#{method_name}_local_authorities" do
            area_local_authorities AreaOfLaw.send(method_name)
          end

          define_method :"#{method_name}_local_authorities_list" do
            area_local_authorities_list AreaOfLaw.send(method_name)
          end

          define_method :"#{method_name}_local_authorities_list=" do |local_authority_names_list|
            set_area_local_authorities_list local_authority_names_list, AreaOfLaw.send(method_name)
          end
          attr_accessible :"#{method_name}_local_authorities_list"

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
