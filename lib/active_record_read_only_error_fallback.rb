# frozen_string_literal: true
require 'active_record'
require 'request_store'
require 'active_record_read_only_error_fallback/version'
require 'active_record_read_only_error_fallback/logging'
require 'active_record_read_only_error_fallback/writable'
require 'active_record_read_only_error_fallback/database_resolver'

module ActiveRecordReadOnlyErrorFallback
  extend Writable

  REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP = 'active_record_read_only_error_fallback.require_update_last_write_timestamp'

  class << self
    def call
      yield
    rescue ActiveRecord::ReadOnlyError => e
      with_writable_connection(e) { yield }
    end

    def logging=(callable)
      Logging.handler = callable
    end
  end
end


ActiveSupport.on_load :active_record do
  db_config = Rails.application.config.database_configuration[Rails.env]
  adapter = db_config.size > 1 ? db_config.values.first['adapter'] : nil
  case adapter
  when 'mysql2'
    require 'active_record_read_only_error_fallback/mysql_database_statements'
  end
end
