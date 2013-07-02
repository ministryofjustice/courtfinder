module CourtsHelper
  def print_view
    /leaflets/i =~ request.env['PATH_INFO']
  end
end
