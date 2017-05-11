class HealthCheckController < ApplicationController

  def ping
    render json: {
      version_number: ENV['APPVERSION'] || 'unknown',
      build_date: ENV['APP_BUILD_DATE'] || 'unknown',
      commit_id: ENV['APP_GIT_COMMIT'] || 'unknown',
      build_tag: ENV['APP_BUILD_TAG'] || 'unknown'
    }
  end

  def healthcheck
    checks = {
      database: database_alive?
    }

    status = checks.values.all?

    render json: {
      checks: checks,
      ok: status
    }
  end

  private

  def database_alive?
    ActiveRecord::Base.connection.active?
  rescue PG::ConnectionBad
    false
  end
end
