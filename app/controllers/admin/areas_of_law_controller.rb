class Admin::AreasOfLawController < Admin::ApplicationController
  # GET /admin/areas_of_law
  # GET /admin/areas_of_law.json
  def index
    @areas_of_law = AreaOfLaw.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @areas_of_law }
    end
  end

  # GET /admin/areas_of_law/1
  # GET /admin/areas_of_law/1.json
  def show
    @area_of_law = AreaOfLaw.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @area_of_law }
    end
  end

  # GET /admin/areas_of_law/new
  # GET /admin/areas_of_law/new.json
  def new
    @area_of_law = AreaOfLaw.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @area_of_law }
    end
  end

  # GET /admin/areas_of_law/1/edit
  def edit
    @area_of_law = AreaOfLaw.find(params[:id])
  end

  # POST /admin/areas_of_law
  # POST /admin/areas_of_law.json
  def create
    @area_of_law = AreaOfLaw.new(params[:area_of_law])

    respond_to do |format|
      if @area_of_law.save
        purge_all_pages
        format.html { redirect_to admin_areas_of_law_path, notice: 'Area of law was successfully created.' }
        format.json { render json: @area_of_law, status: :created, location: @area_of_law }
      else
        format.html { render action: "new" }
        format.json { render json: @area_of_law.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/areas_of_law/1
  # PUT /admin/areas_of_law/1.json
  def update
    @area_of_law = AreaOfLaw.find(params[:id])

    respond_to do |format|
      if @area_of_law.update_attributes(params[:area_of_law])
        purge_all_pages
        format.html { redirect_to admin_areas_of_law_path, notice: 'Area of law was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @area_of_law.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/areas_of_law/1
  # DELETE /admin/areas_of_law/1.json
  def destroy
    @area_of_law = AreaOfLaw.find(params[:id])
    @area_of_law.destroy
    purge_all_pages

    respond_to do |format|
      format.html { redirect_to admin_areas_of_law_url }
      format.json { head :no_content }
    end
  end
end
