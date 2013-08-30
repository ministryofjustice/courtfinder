class Admin::FacilitiesController < Admin::ApplicationController
  # GET /admin/facilities
  # GET /admin/facilities.json
  def index
    @facilities = Facility.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @facilities }
    end
  end

  # GET /admin/facilities/1
  # GET /admin/facilities/1.json
  def show
    @facility = Facility.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @facility }
    end
  end

  # GET /admin/facilities/new
  # GET /admin/facilities/new.json
  def new
    @facility = Facility.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @facility }
    end
  end

  # GET /admin/facilities/1/edit
  def edit
    @facility = Facility.find(params[:id])
  end

  # POST /admin/facilities
  # POST /admin/facilities.json
  def create
    @facility = Facility.new(params[:facility])

    respond_to do |format|
      if @facility.save
        purge_all_pages
        format.html { redirect_to admin_facility_path(@facility), notice: 'Facility type was successfully created.' }
        format.json { render json: @facility, status: :created, location: @facility }
      else
        format.html { render action: "new" }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/facilities/1
  # PUT /admin/facilities/1.json
  def update
    @facility = Facility.find(params[:id])

    respond_to do |format|
      if @facility.update_attributes(params[:facility])
        purge_all_pages
        format.html { redirect_to admin_facility_path(@facility), notice: 'Facility type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/facilities/1
  # DELETE /admin/facilities/1.json
  def destroy
    @facility = Facility.find(params[:id])
    @facility.destroy
    purge_all_pages

    respond_to do |format|
      format.html { redirect_to admin_facilities_url }
      format.json { head :no_content }
    end
  end
end
