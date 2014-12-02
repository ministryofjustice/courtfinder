module Concerns
  module Court
    module LocalAuthorities
      extend ActiveSupport::Concern

      included do
        attr_accessor :invalid_local_authorities

        has_many :jurisdictions, through: :remits
        has_many :local_authorities, through: :jurisdictions

        def area_local_authorities_list(area_of_law = nil)
          relation = area_local_authorities(area_of_law)
          relation.map(&:name).join(',')
        end

        def area_local_authorities(area_of_law)
          local_authorities.by_name.where remits: { area_of_law_id: area_of_law.id }
        end

        def set_area_local_authorities_list(local_authority_names_list, area_of_law)
          local_authority_names = local_authority_names_list.split(',')
          local_authorities = LocalAuthority.where(name: local_authority_names)

          self.invalid_local_authorities = local_authority_names - local_authorities.map(&:name)
          remits.where(area_of_law_id: area_of_law.id).first_or_create!.local_authorities = local_authorities
        end

        def single_point_of_entry_for?(area_of_law)
          remit = remits.find_by_area_of_law_id(area_of_law.id)
          remit.present? && remit.single_point_of_entry?
        end

        def set_single_point_of_entry_for(area_of_law, value)
          remit = remits.where(area_of_law_id: area_of_law.id).first_or_create!
          remit.single_point_of_entry = value
          remit.save!
        end

        %i(children divorce adoption).each do |method_name|
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
