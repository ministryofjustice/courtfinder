class Admin::OpeningTypesController < Admin::ApplicationController
  # GET /admin/opening_types
  # GET /admin/opening_types.json
  def index
    @opening_types = OpeningType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @opening_types }
    end
  end

  # GET /admin/opening_types/1
  # GET /admin/opening_types/1.json
  def show
    @opening_type = OpeningType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @opening_type }
    end
  end

  # GET /admin/opening_types/new
  # GET /admin/opening_types/new.json
  def new
    @opening_type = OpeningType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @opening_type }
    end
  end

  # GET /admin/opening_types/1/edit
  def edit
    @opening_type = OpeningType.find(params[:id])
  end

  # POST /admin/opening_types
  # POST /admin/opening_types.json
  def create
    @opening_type = OpeningType.new(params[:opening_type])

    respond_to do |format|
      if @opening_type.save
        purge_all_pages
        format.html { redirect_to admin_opening_type_path(@opening_type), notice: 'Opening type was successfully created.' }
        format.json { render json: @opening_type, status: :created, location: @opening_type }
      else
        format.html { render action: "new" }
        format.json { render json: @opening_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/opening_types/1
  # PUT /admin/opening_types/1.json
  def update
    @opening_type = OpeningType.find(params[:id])

    respond_to do |format|
      if @opening_type.update_attributes(params[:opening_type])
        purge_all_pages
        format.html { redirect_to admin_opening_type_path(@opening_type), notice: 'Opening type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @opening_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/opening_types/1
  # DELETE /admin/opening_types/1.json
  def destroy
    @opening_type = OpeningType.find(params[:id])
    @opening_type.destroy
    purge_all_pages

    respond_to do |format|
      format.html { redirect_to admin_opening_types_url }
      format.json { head :no_content }
    end
  end
end
