class GovUkPushWorker

  include Sidekiq::Worker
  
  def perform(options)
    pusher = GovUkPusher.new(options)
    pusher.push
  end

end
