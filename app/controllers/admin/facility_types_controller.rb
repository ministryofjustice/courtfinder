class Admin::FacilityTypesController < ApplicationController
  before_filter :authenticate_user!

  # GET /admin/facility_types
  # GET /admin/facility_types.json
  def index
    @facility_types = FacilityType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @facility_types }
    end
  end

  # GET /admin/facility_types/1
  # GET /admin/facility_types/1.json
  def show
    @facility_type = FacilityType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @facility_type }
    end
  end

  # GET /admin/facility_types/new
  # GET /admin/facility_types/new.json
  def new
    @facility_type = FacilityType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @facility_type }
    end
  end

  # GET /admin/facility_types/1/edit
  def edit
    @facility_type = FacilityType.find(params[:id])
  end

  # POST /admin/facility_types
  # POST /admin/facility_types.json
  def create
    @facility_type = FacilityType.new(params[:facility_type])

    respond_to do |format|
      if @facility_type.save
        format.html { redirect_to admin_facility_type_path(@facility_type), notice: 'Facility type was successfully created.' }
        format.json { render json: @facility_type, status: :created, location: @facility_type }
      else
        format.html { render action: "new" }
        format.json { render json: @facility_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/facility_types/1
  # PUT /admin/facility_types/1.json
  def update
    @facility_type = FacilityType.find(params[:id])

    respond_to do |format|
      if @facility_type.update_attributes(params[:facility_type])
        format.html { redirect_to admin_facility_type_path(@facility_type), notice: 'Facility type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @facility_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/facility_types/1
  # DELETE /admin/facility_types/1.json
  def destroy
    @facility_type = FacilityType.find(params[:id])
    @facility_type.destroy

    respond_to do |format|
      format.html { redirect_to admin_facility_types_url }
      format.json { head :no_content }
    end
  end
end
