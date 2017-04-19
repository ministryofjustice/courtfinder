class Admin::AreasController < Admin::ApplicationController
  before_action :authorised?

  # GET /admin/areas
  # GET /admin/areas.json
  def index
    @areas = Area.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @areas }
    end
  end

  # GET /admin/areas/1
  # GET /admin/areas/1.json
  def show
    @area = Area.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @area }
    end
  end

  # GET /admin/areas/new
  # GET /admin/areas/new.json
  def new
    @area = Area.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @area }
    end
  end

  # GET /admin/areas/1/edit
  def edit
    @area = Area.find(params[:id])
  end

  # POST /admin/areas
  # POST /admin/areas.json
  def create
    @area = Area.new(params[:area])

    respond_to do |format|
      if @area.save
        purge_all_pages
        format.html { redirect_to edit_admin_area_path(@area), notice: 'Area was successfully created.' }
        format.json { render json: @area, status: :created, location: admin_area_url(@area) }
      else
        format.html { 
          flash[:error] = 'Area could not be created'
          render action: "new" 
        }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/areas/1
  # PUT /admin/areas/1.json
  def update
    @area = Area.find(params[:id])

    respond_to do |format|
      if @area.update_attributes(params[:area])
        purge_all_pages
        format.html { redirect_to edit_admin_area_path(@area), notice: 'Area was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { 
          flash[:error] = 'Area could not be updated'
          render action: "edit" 
        }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/areas/1
  # DELETE /admin/areas/1.json
  def destroy
    @area = Area.find(params[:id])
    @area.destroy
    purge_all_pages

    respond_to do |format|
      format.html { redirect_to admin_areas_url }
      format.json { head :no_content }
    end
  end
end
