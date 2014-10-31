class Admin::LocalAuthoritiesController < Admin::ApplicationController
  respond_to :html, :json

	def index
		@local_authorities = LocalAuthority.by_name
		respond_with @local_authorities
	end

	def show
		@local_authority = LocalAuthority.find(params[:id])
		respond_with @local_authority
	end

	def new
		@local_authority = LocalAuthority.new
		respond_with @local_authority
	end

	def create
		@local_authority = LocalAuthority.new(params[:local_authority])
		flash[:notice] ='Local authority was successfully updated.' if @local_authority.save
		purge_all_pages
		respond_with @local_authority, location: admin_local_authorities_path
	end

	def edit
		@local_authority = LocalAuthority.find(params[:id])
		respond_with @local_authority
	end

	def update
		@local_authority = LocalAuthority.find(params[:id])
		flash[:notice] ='Local authority was successfully updated.' if @local_authority.update_attributes(params[:local_authority])
		purge_all_pages
		respond_with @local_authority, location: admin_local_authorities_path
	end

	def destroy
		@local_authority = LocalAuthority.find(params[:id])
		flash[:notice] ='Local authority was deleted.' if @local_authority.destroy
		
		respond_with @local_authority, location: admin_local_authorities_path
	end

  def complete
    @local_authorities = LocalAuthority.search(params[:term])
    respond_with @local_authorities.map(&:name)
  end
  
end
