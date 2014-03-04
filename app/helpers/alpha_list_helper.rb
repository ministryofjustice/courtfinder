module AlphaListHelper

  def initial_list(collection, key = 'name')
    collection.is_a?(Enumerable) ? collection.group_by{ |item| item.send(key).first.upcase } : collection
  end

  # Return the alphabet as links or del tag where not found in collection
  def a_to_z(list, type = 'courts')
    # store a list of initial letters
    html = []
    ('A'..'Z').each do |letter|
      html << content_tag(:li) do
        if list.is_a?(Enumerable) && list.include?(letter)
          link_to letter, "##{type}-by-#{letter.downcase}"
        else
          content_tag :del do
            letter
          end
        end
      end
    end

    html.join.html_safe
  end

end