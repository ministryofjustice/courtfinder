class HeartbeatController < ApplicationController
  def ping
    @json = File.read("#{Rails.root}/public/ping.json") rescue '{}'
    render json: @json
  end

  def healthcheck
    checks = {
      database: database_alive?
    }

    status = :bad_gateway unless checks.values.all?
    render status: status, json: {
      checks: checks
    }
  end

  private

  def database_alive?
    begin
      ActiveRecord::Base.connection.active?
    rescue PG::ConnectionBad
      false
    end
  end
end
