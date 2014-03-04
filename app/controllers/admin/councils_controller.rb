class Admin::CouncilsController < Admin::ApplicationController
	respond_to :html, :json
	
	def index
		@councils = Council.by_name
		respond_with @councils
	end

end