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

    html.join.html_safe
  end

  def display_court_numbers(court)
    court_numbers = []
    if court.court_number.present? && court.court_number != 0
      court_numbers << "##{court.court_number}"
    end

    if court.cci_code.present? && court.cci_code != court.court_number
      court_numbers << "CCI #{court.cci_code}"
    end
    court_numbers.join(', ')
  end
end
