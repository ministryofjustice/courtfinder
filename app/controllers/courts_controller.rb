class CourtsController < ApplicationController
  
  respond_to :html, :json
  
  def index 
    @courts = Court.all
    
    if params[:search]
	  reg = /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1}))\d[abd-hjlnp-uw-z]{2})$/i
	  
	  # When postcode...
	  if reg =~ params[:search].strip

	    r = RestClient.post 'http://devcfphp/postcode_finder.php', { :searchtext => params[:search], :searchbtn => 'Submit' }
        #puts r
        j = JSON.parse(r)
        #puts j
		courts = @courts.map{|c|{'id' => c.id, 'courtname' => c.name, 'lat' => c.latitude.to_f, 'long' => c.longitude.to_f}}
		puts courts
	    in_radius = postcode_distance(j[0], courts)

        in_radius = in_radius.sort_by { |k, v| v[:distance] }
		
		@courts = in_radius

        if (in_radius) 		
	      puts "The courts within a 20 mile radius are:"
	      in_radius.each do |key, hash|
	        puts hash[:name] + " at " + hash[:distance].to_s + " miles"
	      end
        end
		
	  else
	
        @courts = Court.search(params[:search], params[:page], params[:per_page] || 15)
	  
	  end
	
	end
	
    respond_with @courts
  end
  
  def show
    @court = Court.find(params[:id])

    if request.path != court_path(@court, :format => params[:format])
      redirect_to court_path(@court, :format => params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end
  
	def deg2rad(d)
		d * Math::PI / 180
	end

	def rad2deg(r)
		r * 180 / Math::PI
	end

	def distance (lat1, lon1, lat2, lon2, u = 1)
		
		#puts lat1
		#puts lon1
		d=Math.sin(deg2rad(lat1))*Math.sin(deg2rad(lat2))+Math.cos(deg2rad(lat1))*Math.cos(deg2rad(lat2))*Math.cos(deg2rad(lon1-lon2));
		d=rad2deg(Math.acos(d));
		d=d*60*1.1515;

		d=(d*u); # apply unit
		d=d.round(2)	# optional rounding up of the distance to nearest hundredth of a mile
			
		return d;
	end

	def closest(haystack)
		
		inrange = {}
		
		haystack.each do |key, hash|
			if (hash[:distance] < 20)
				inrange[key] = {:name => hash[:name], :distance => hash[:distance]}
			end
		end
		
		return inrange;
	end

	def postcode_distance(coords, courts)

		checkdistance = {}

		courts.each do |hash|
			#puts coords['lat']
			court_distance = distance(coords['lat'], coords['long'], hash['lat'], hash['long'])
			checkdistance[hash['id']] = {:name => hash['courtname'], :distance => court_distance}
			#puts checkdistance[hash['id']]
		end
		
		
		withinrange = closest(checkdistance)
		
		return withinrange
		
	end

end
