class Admin::LocalAuthoritiesController < Admin::ApplicationController
  respond_to :html, :json

	def index
		@local_authorities = LocalAuthority.by_name
		respond_with @local_authorities
	end

	def new
		@local_authority = LocalAuthority.new
		respond_with @local_authority
	end

	def create
		@local_authority = LocalAuthority.new(params[:local_authority])
		if @local_authority.save
			flash[:notice] ='Local authority was successfully updated.' 
			purge_all_pages
			respond_with @local_authority, location: admin_local_authorities_path
		else
			flash[:error] = 'Local authority could not be created.'
			render :new
		end
	end

	def edit
		@local_authority = LocalAuthority.find(params[:id])
		respond_with @local_authority
	end

	def update
		@local_authority = LocalAuthority.find(params[:id])
		if @local_authority.update_attributes(params[:local_authority])
			flash[:notice] ='Local authority was successfully updated.'
			purge_all_pages
			respond_with @local_authority, location: admin_local_authorities_path
		else
			flash[:error] = 'Local authority could not be updated.'
			render :edit
		end
	end

	def destroy
		@local_authority = LocalAuthority.find(params[:id])
		if @local_authority.destroy
			flash[:notice] ='Local authority was deleted.' 
		else
			flash[:error] = 'Local authority could not be deleted.'
		end
		
		respond_with @local_authority, location: admin_local_authorities_path
	end

  def complete
    @local_authorities = LocalAuthority.search(params[:term])
    respond_with @local_authorities.map(&:name)
  end
  
end
