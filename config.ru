# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
Rack::Utils.multipart_part_limit = 0
run Courtfinder::Application
