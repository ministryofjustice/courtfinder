class Admin::AddressTypesController < Admin::ApplicationController
  # GET /address_types
  # GET /address_types.json
  def index
    @address_types = AddressType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @address_types }
    end
  end

  # GET /address_types/1
  # GET /address_types/1.json
  def show
    @address_type = AddressType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @address_type }
    end
  end

  # GET /address_types/new
  # GET /address_types/new.json
  def new
    @address_type = AddressType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @address_type }
    end
  end

  # GET /address_types/1/edit
  def edit
    @address_type = AddressType.find(params[:id])
  end

  # POST /address_types
  # POST /address_types.json
  def create
    @address_type = AddressType.new(params[:address_type])

    respond_to do |format|
      if @address_type.save
        format.html { redirect_to edit_admin_address_type_path(@address_type), notice: 'Address type was successfully created.' }
        format.json { render json: @address_type, status: :created, location: @address_type }
      else
        format.html { render action: "new" }
        format.json { render json: @address_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /address_types/1
  # PUT /address_types/1.json
  def update
    @address_type = AddressType.find(params[:id])

    respond_to do |format|
      if @address_type.update_attributes(params[:address_type])
        format.html { redirect_to edit_admin_address_type_path(@address_type), notice: 'Address type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @address_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /address_types/1
  # DELETE /address_types/1.json
  def destroy
    @address_type = AddressType.find(params[:id])
    @address_type.destroy

    respond_to do |format|
      format.html { redirect_to admin_address_types_url }
      format.json { head :no_content }
    end
  end
end
