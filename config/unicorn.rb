worker_processes 4
listen File.absolute_path(File.join(__FILE__, '../../tmp/unicorn.sock')), :backlog => 64
working_directory File.absolute_path(File.join(__FILE__, '../..'))
pid File.absolute_path(File.join(__FILE__, '../../tmp/pids/unicorn.pid'))
timeout 30
preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
