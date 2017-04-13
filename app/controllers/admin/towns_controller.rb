class Admin::TownsController < Admin::ApplicationController
  # GET /towns
  # GET /towns.json
  def index
    @towns = Town.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @towns }
    end
  end

  # GET /towns/1
  # GET /towns/1.json
  def show
    @town = Town.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @town }
    end
  end

  # GET /towns/new
  # GET /towns/new.json
  def new
    @town = Town.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @town }
    end
  end

  # GET /towns/1/edit
  def edit
    @town = Town.find(params[:id])
  end

  # POST /towns
  # POST /towns.json
  def create
    @town = Town.new(params[:town])

    respond_to do |format|
      if @town.save
        purge_all_pages
        format.html { redirect_to admin_town_path(@town), notice: 'Town was successfully created.' }
        format.json { render json: @town, status: :created, location: admin_town_url(@town) }
      else
        format.html { render action: "new" }
        format.json { render json: @town.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /towns/1
  # PUT /towns/1.json
  def update
    @town = Town.find(params[:id])

    respond_to do |format|
      if @town.update_attributes(params[:town])
        purge_all_pages
        format.html { redirect_to admin_town_path(@town), notice: 'Town was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @town.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /towns/1
  # DELETE /towns/1.json
  def destroy
    @town = Town.find(params[:id])
    @town.destroy
    purge_all_pages

    respond_to do |format|
      format.html { redirect_to admin_towns_url }
      format.json { head :no_content }
    end
  end
end
