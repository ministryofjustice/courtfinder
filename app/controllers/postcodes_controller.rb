class PostcodesController < ApplicationController
  respond_to :csv

  before_filter :enable_varnish
  before_filter :set_vary_accept, only: [:index, :show]

  def repossession
    set_cache_control(Court.maximum(:updated_at)) && return
    @postcode_courts = PostcodeCourt.includes(:court).all
    respond_to do |format|
        format.csv do
          render text: postcodes_csv
        end
    end
  end

  private

  def postcodes_csv
    CSV.generate do |csv|
      csv << ["Post code", "Court name", "Court number"]
      @postcode_courts.each do |postcode|
        csv << [postcode.postcode, postcode.court.name, postcode.court.cci_code ? postcode.court.cci_code : postcode.court.court_number]
      end
    end
  end

end
