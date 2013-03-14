class Admin::CourtTypesController < ApplicationController
  before_filter :authenticate_user!

  # GET /admin/court_types
  # GET /admin/court_types.json
  def index
    @court_types = CourtType.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @court_types }
    end
  end

  # GET /admin/court_types/1
  # GET /admin/court_types/1.json
  def show
    @court_type = CourtType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @court_type }
    end
  end

  # GET /admin/court_types/new
  # GET /admin/court_types/new.json
  def new
    @court_type = CourtType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @court_type }
    end
  end

  # GET /admin/court_types/1/edit
  def edit
    @court_type = CourtType.find(params[:id])
  end

  # POST /admin/court_types
  # POST /admin/court_types.json
  def create
    @court_type = CourtType.new(params[:court_type])

    respond_to do |format|
      if @court_type.save
        format.html { redirect_to admin_court_type_path(@court_type), notice: 'Court type was successfully created.' }
        format.json { render json: @court_type, status: :created, location: @court_type }
      else
        format.html { render action: "new" }
        format.json { render json: @court_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/court_types/1
  # PUT /admin/court_types/1.json
  def update
    @court_type = CourtType.find(params[:id])

    respond_to do |format|
      if @court_type.update_attributes(params[:court_type])
        format.html { redirect_to admin_court_type_path(@court_type), notice: 'Court type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @court_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/court_types/1
  # DELETE /admin/court_types/1.json
  def destroy
    @court_type = CourtType.find(params[:id])
    @court_type.destroy

    respond_to do |format|
      format.html { redirect_to admin_court_types_url }
      format.json { head :no_content }
    end
  end
end
