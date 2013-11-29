class Admin::CourtsController < Admin::ApplicationController
  # GET /courts
  # GET /courts.json
  def index
    @courts = Court.by_name

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
    @court_contacts = @court.contacts.order(:sort)
  end

  # POST /courts
  # POST /courts.json
  def create
    @court = Court.new(params[:court])

    respond_to do |format|
      if @court.save
        purge_all_pages
        format.html { redirect_to edit_admin_court_path(@court), notice: 'Page was successfully created.' }
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
        purge_all_pages
        format.html { redirect_to edit_admin_court_path(@court), notice: 'Page was successfully updated.' }
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
    purge_all_pages

    respond_to do |format|
      format.html { redirect_to admin_courts_url }
      format.json { head :no_content }
    end
  end

  def areas_of_law
    @courts = Court.by_name.paginate(:page => params[:page], :per_page => 30)
    @areas_of_law = AreaOfLaw.all
  end

  def court_types
    @courts = Court.by_name.paginate(:page => params[:page], :per_page => 30)
    @court_types = CourtType.order(:name)
  end

  def postcode
    @courts = Court.by_name.paginate(:page => params[:page], :per_page => 30)
    @postcode_courts = PostcodeCourt.all
  end

  def update_postcodes
    puts "================================="
    puts params
    #
    render nothing: true, status: :ok
  end  
end
