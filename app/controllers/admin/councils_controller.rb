class Admin::CouncilsController < Admin::ApplicationController
  respond_to :html, :json

	def index
		@councils = LocalAuthority.by_name
		respond_with @councils
	end

	def show
		@council = LocalAuthority.find(params[:id])
		respond_with @council
	end

	def new
		@council = LocalAuthority.new
		respond_with @council
	end

	def create
		@council = LocalAuthority.new(params[:council])
		flash[:notice] ='Council was successfully updated.' if @council.save
		purge_all_pages
		respond_with @council, location: admin_councils_path
	end

	def edit
		@council = LocalAuthority.find(params[:id])
		respond_with @council
	end

	def update
		@council = LocalAuthority.find(params[:id])
		flash[:notice] ='Council was successfully updated.' if @council.update_attributes(params[:council])
		purge_all_pages
		respond_with @council, location: admin_councils_path
	end

	def destroy
		@council = LocalAuthority.find(params[:id])
		flash[:notice] ='Council was deleted.' if @council.destroy
		
		respond_with @council, location: admin_councils_path
	end

  def complete
    @councils = LocalAuthority.search(params[:term])
    respond_with @councils.map(&:name)
  end
  
end