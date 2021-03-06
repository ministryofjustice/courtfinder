module Admin
  class PostcodesController < Admin::ApplicationController
    before_action :authorised?

    def edit
      render_edit
    end

    def update
      if postcodes.present?
        PostcodeCourt.transaction do
          ps_courts = PostcodeCourt.where('court_id = ? and id in (?)',
            params[:court][:court_id].to_i, postcodes)
          update_postcode_courts(ps_courts)
        end
      end
      flash_message
      render_edit
    end

    private

    def render_edit
      @court = Court.includes(:postcode_courts).find(params[:id])
      @courts = Court.by_area_of_law(list_of_law_areas).where.not(id: params[:id]).order(:name)

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
        flash.now[:move_info] = updated_postcodes_message
      end
    end

    def list_of_law_areas
      [AreaOfLaw::Name::MONEY_CLAIMS,
       AreaOfLaw::Name::HOUSING_POSSESSION,
       AreaOfLaw::Name::BANKRUPTCY]
    end

    def update_postcode_courts(ps_courts)
      ps_courts.each do |ps_court|
        if ps_court.update(court_id: params[:move_to][:court].to_i)
          updated_postcodes << ps_court.postcode
        else
          not_updated_postcodes << ps_court.postcode
        end
      end
    end

    def updated_postcodes_message
      if not_updated_postcodes.blank? && updated_postcodes.present?
        '%s postcode(s) moved successfully.' % postcodes.count.to_s
      else
        valid = "#{updated_postcodes.count} postcode(s) moved successfully."
        not_valid = "#{not_updated_postcodes.count} postcode(s) not moved because are not valid."
        "#{valid} #{not_valid}"
      end
    end

    def not_updated_postcodes
      @not_updated_postcodes ||= []
    end

    def updated_postcodes
      @updated_postcodes ||= []
    end
  end
end
