module Admin
  module CourtsHelper
    # needed as in production, the /courts/slug urls
    # are redirected to the python app
    def external_court_path(court)
      ["/courts", court.slug].join('/')
    end
  end
end
