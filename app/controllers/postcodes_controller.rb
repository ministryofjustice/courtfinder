class PostcodesController < ApplicationController
  respond_to :csv

  before_filter :set_vary_accept, only: [:index, :show]

  def repossession
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
      csv << ["Post code", "Court URL", "Court name", "Court number"]
      @postcode_courts.each do |postcode|
        csv << [postcode.postcode, court_path(postcode.court), postcode.court.name, (postcode.court.cci_code || '?')]
      end
    end
  end

end
