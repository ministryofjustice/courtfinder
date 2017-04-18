module Admin
  class PostcodesController < Admin::ApplicationController
    before_action :authorised?

    def edit
      render_edit
    end

    def update
      if postcodes.present?
        PostcodeCourt.transaction do
          PostcodeCourt.where('court_id = ? and id in (?)',
            params[:court][:court_id].to_i,
            postcodes).
            update_all(court_id: params[:move_to][:court].to_i)
        end
      end
      flash_message
      render_edit
    end

    private

    def render_edit
      @court = Court.includes(:postcode_courts).find(params[:id])
      @courts = Court.by_area_of_law([
        AreaOfLaw::Name::MONEY_CLAIMS,
        AreaOfLaw::Name::HOUSING_POSSESSION,
        AreaOfLaw::Name::BANKRUPTCY]).
                where.not(id: params[:id]).order(:name)

      if flash[:move_info].nil? && @court.postcode_courts.empty?
        flash.now[:info] = 'No postcodes to move.'
      end

      render template: 'admin/postcodes/_move'
    end

    def postcodes
      return [] if params[:court][:postcode_courts].blank?
      params[:court][:postcode_courts].map(&:to_i)
    end

    def flash_message
      if postcodes.blank?
        flash.now[:move_info] = 'No postcodes selected.'
      else
        flash.now[:move_info] = '%s postcode(s) moved successfully.' % postcodes.count.to_s
      end
    end
  end
end
