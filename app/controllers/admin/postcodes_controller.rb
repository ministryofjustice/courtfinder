class Admin::PostcodesController < Admin::ApplicationController
  before_filter :authorised?, :only => [:audit, :audit_csv, :get_association_changeset]

  # GET /courts/postcodes/1/edit
  def edit
    #byebug
    # @court = Court.includes(:postcode_courts).find(params[:id])
    # @courts = Court.by_area_of_law([AreaOfLaw::Name::MONEY_CLAIMS, 
    #     AreaOfLaw::Name::HOUSING_POSSESSION, 
    #     AreaOfLaw::Name::BANKRUPTCY]).where.not(id: params[:id]).order(:name)
    render_edit
    #render :template => 'admin/postcodes/_move'
    return
  end

  # PUT /courts/postcode/1
  # PUT /courts/postcode/1.json
  def update
    #byebug
    postcodes = params[:court][:postcode_courts].map {|i| i.to_i}
    PostcodeCourt.transaction do
      PostcodeCourt.where('court_id = ? and id in (?)', 
        params[:court][:court_id].to_i, 
        postcodes).
        update_all(:court_id => params[:move_to][:court].to_i) 
      end
    
    render_edit #:layout => 'layouts/application'
    # edit
    return
  end

private
  def render_edit
    #byebug
    @court = Court.includes(:postcode_courts).find(params[:id])
    @courts = Court.by_area_of_law([AreaOfLaw::Name::MONEY_CLAIMS, 
        AreaOfLaw::Name::HOUSING_POSSESSION, 
        AreaOfLaw::Name::BANKRUPTCY]).where.not(id: params[:id]).order(:name)
    render :template => 'admin/postcodes/_move'
  end

end
