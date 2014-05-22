module SearchHelper

  def family_court_search_found(search, area_of_law)
    "#{'Court'.pluralize(search.results.size)} dealing with applications involving #{area_of_law.name.downcase} for <strong>#{search.query}</strong>".html_safe
  end

  def area_of_law_groups(selected)
    grouped_data = AreaOfLawGroup.with_areas_of_law.order('areas_of_law.name').includes(:areas_of_law).all
    if AreaOfLaw.where(group_id: nil).count > 0
      other = AreaOfLawGroup.new(name: 'Other')
      other.areas_of_law = AreaOfLaw.where(group_id: nil).all.to_a
      grouped_data << other
    end
    grouped_data

    html = content_tag(:option, 'All law', value: 'all')
    grouped_data.each do |group|
      html << content_tag(:optgroup, label: group.name) do
        group.areas_of_law.each do |area|
          concat content_tag(:option, area.name, selected: (area.name == selected) )
        end
      end
    end

    html
  end

end
