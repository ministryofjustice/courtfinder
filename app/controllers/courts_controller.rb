class CourtsController < ApplicationController
  # GET /courts
  # GET /courts.json
  def index
    @courts = Court.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courts }
    end
  end

  # GET /courts/1
  # GET /courts/1.json
  def show
    @court = Court.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @court }
    end
  end

  # GET /courts/new
  # GET /courts/new.json
  def new
    @court = Court.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @court }
    end
  end

  # GET /courts/1/edit
  def edit
    @court = Court.find(params[:id])
  end

  # POST /courts
  # POST /courts.json
  def create
    @court = Court.new(params[:court])

    respond_to do |format|
      if @court.save
        format.html { redirect_to @court, notice: 'Court was successfully created.' }
        format.json { render json: @court, status: :created, location: @court }
      else
        format.html { render action: "new" }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courts/1
  # PUT /courts/1.json
  def update
    @court = Court.find(params[:id])

    respond_to do |format|
      if @court.update_attributes(params[:court])
        format.html { redirect_to @court, notice: 'Court was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courts/1
  # DELETE /courts/1.json
  def destroy
    @court = Court.find(params[:id])
    @court.destroy

    respond_to do |format|
      format.html { redirect_to courts_url }
      format.json { head :no_content }
    end
  end
end
