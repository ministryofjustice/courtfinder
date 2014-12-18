class GovUkPushWorker

  include Sidekiq::Worker

  def perform(options)
    Rails.logger.info "GovUkPushWorker #{options.inspect}"
  end


end
