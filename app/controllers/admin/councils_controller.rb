class Admin::CouncilsController < Admin::ApplicationController
	respond_to :html, :json
	
	def index
		@councils = Council.by_name
		respond_with @councils
	end

	def show
		@council = Council.find(params[:id])
		respond_with @council
	end

	def new
		@council = Council.new
		respond_with @council
	end

	def create
		@council = Council.new(params[:council])
		flash[:notice] ='Council was successfully updated.' if @council.save
		purge_all_pages
		respond_with @council, location: admin_councils_path
	end

	def edit
		@council = Council.find(params[:id])
		respond_with @council
	end

	def update
		@council = Council.find(params[:id])
		flash[:notice] ='Council was successfully updated.' if @council.update_attributes(params[:council])
		purge_all_pages
		respond_with @council, location: admin_councils_path
	end

	def destroy
		@council = Council.find(params[:id])
		@council.destroy
		respond_with @council
	end

end