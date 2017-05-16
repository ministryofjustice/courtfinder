module AlphaListHelper

  def initial_list(collection, key = 'name')
    collection.respond_to?(:each) ? collection_grouped(collection, key) : collection
  end

  # Return the alphabet as links or del tag where not found in collection
  def a_to_z(list, type = 'courts')
    # store a list of initial letters
    html = []
    ('A'..'Z').each do |letter|
      html << list_item(letter, list, type)
    end

    safe_join(html)
  end

  private

  def collection_grouped(collection, key)
    collection.group_by { |item| item.send(key).first.upcase }
  end

  def list_item(letter, list, type)
    content_tag(:li) do
      if list.respond_to?(:each) && list.include?(letter)
        link_to letter, "##{type}-by-#{letter.downcase}"
      else
        content_tag :del, letter
      end
    end
  end
end
