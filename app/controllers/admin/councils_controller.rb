class Admin::CouncilsController < Admin::ApplicationController
	#before_filter :authorised?, :only => [:audit, :audit_csv, :get_association_changeset]

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
		@council.save
		purge_all_pages
		respond_with @council
	end

	def edit
		@council = Council.find(params[:id])
		responde_with @council
	end

	def update
		@council = Council.find(params[:id])
		@council.update_attributes(params[:council])
		purge_all_pages
		respond_with @council
	end

	def destroy
		@council = Council.find(params[:id])
		@council.destroy
		respond_with @council
	end

end