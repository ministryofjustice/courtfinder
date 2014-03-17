module SearchHelper

  def family_court_search_found(search, area_of_law)
    "#{'Court'.pluralize(search.results.size)} dealing with applications involving #{area_of_law.name.downcase} for <strong>#{search.query}</strong>".html_safe
  end

end