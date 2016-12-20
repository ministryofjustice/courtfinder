class Admin::PostcodesController < Admin::ApplicationController
  before_filter :authorised?, :only => [:audit, :audit_csv, :get_association_changeset]

  # GET /courts/postcodes/1/edit
  def edit
    render_edit
    return
  end

  # PUT /courts/postcode/1
  # PUT /courts/postcode/1.json
  def update
    postcodes = params[:court][:postcode_courts].map {|i| i.to_i} unless params[:court][:postcode_courts].nil?
    postcodes = [] unless not postcodes.nil?

    if not postcodes.empty?
      PostcodeCourt.transaction do
        PostcodeCourt.where('court_id = ? and id in (?)', 
          params[:court][:court_id].to_i, 
          postcodes).
          update_all(:court_id => params[:move_to][:court].to_i) 
        end
    end
    flash.now[:move_info] = '%s postcode(s) moved successfully.' % postcodes.count.to_s
    flash.now[:move_info] = 'No postcodes selected.' unless not postcodes.empty?
    render_edit
    return
  end

private
  def render_edit
    @court = Court.includes(:postcode_courts).find(params[:id])
    @courts = Court.by_area_of_law([AreaOfLaw::Name::MONEY_CLAIMS, 
        AreaOfLaw::Name::HOUSING_POSSESSION, 
        AreaOfLaw::Name::BANKRUPTCY]).where.not(id: params[:id]).order(:name)

    flash.now[:info] = 'No postcodes to move.' if flash[:move_info].nil? and @court.postcode_courts.empty?

    render :template => 'admin/postcodes/_move'
  end

end
