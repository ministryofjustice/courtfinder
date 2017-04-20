module Admin
  class TownsController < Admin::ApplicationController
    before_action :authorised?
    before_filter :find_town, except: [:index, :new, :create]
    respond_to :html, :json

    def index
      @towns = Town.all
      respond_with @towns
    end

    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @town }
      end
    end

    def new
      @town = Town.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @town }
      end
    end

    def edit
      respond_with @town
    end

    def create
      @town = Town.new(params[:town])
      respond_to do |format|
        if @town.save
          message = 'Town was successfully created.'
          format.html { redirect_to admin_town_path(@town), notice: message }
          format.json { render json: @town, status: :created, location: admin_town_url(@town) }
        else
          format.html { render action: "new" }
          format.json { render json: @town.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @town.update_attributes(params[:town])
          message = 'Town was successfully updated.'
          format.html { redirect_to admin_town_path(@town), notice: message }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @town.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @town.destroy

      respond_to do |format|
        format.html { redirect_to admin_towns_url }
        format.json { head :no_content }
      end
    end

    private

    def find_town
      @town ||= Town.find(params[:id])
    end
  end
end
