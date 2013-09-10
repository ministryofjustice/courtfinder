module CourtsHelper
  def print_view
    /leaflets/i =~ request.env['PATH_INFO']
  end

  def initial_list(collection)
    collection.group_by{ |item| item.name.first.upcase }
  end

  # Return the alphabet as links or del tag where not found in collection
  def a_to_z(list)
    # store a list of initial letters
    html = []

    ('A'..'Z').each do |letter|
      html << content_tag(:li) do
        if list.include? letter
          link_to letter, "#courts-by-#{letter.downcase}"
        else
          content_tag :del do
            letter
          end
        end
      end
    end

    html.join
  end
end
