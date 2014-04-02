class PostcodesController < ApplicationController
  respond_to :csv

  before_filter :enable_varnish
  before_filter :set_vary_accept, only: [:index, :show]

  def repossession
    set_cache_control(Court.maximum(:updated_at)) && return
    @postcode_courts = PostcodeCourt.all
    respond_to do |format|
        format.csv do
          render text: postcodes_csv
        end
    end
  end

  private

  def postcodes_csv
    @courts_by_id = Hash[Court.all.index_by(&:id)]
    CSV.generate do |csv|
      csv << ["Post code", "Court name", "CCI Code"]
      @postcode_courts.each do |postcode|
        @court = @courts_by_id[postcode.court_id]
        csv << [postcode.postcode, @court.name, @court.cci_code ? @court.cci_code : @court.cci_code]
      end
    end
  end

end
