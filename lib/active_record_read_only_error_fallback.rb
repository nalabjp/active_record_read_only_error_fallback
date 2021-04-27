# frozen_string_literal: true
require 'active_record'
require 'request_store'
require 'active_record_read_only_error_fallback/version'
require 'active_record_read_only_error_fallback/logging'
require 'active_record_read_only_error_fallback/writable'
require 'active_record_read_only_error_fallback/query_fallback'
require 'active_record_read_only_error_fallback/database_resolver'

module ActiveRecordReadOnlyErrorFallback
  REQUIRE_UPDATE_LAST_WRITE_TIMESTAMP = 'active_record_read_only_error_fallback.require_update_last_write_timestamp'

  def self.logging=(callable)
    Logging.handler = callable
  end
end


ActiveSupport.on_load :active_record do
  db_config = Rails.application.config.database_configuration[Rails.env]
  adapter = db_config.size > 1 ? db_config.values.first['adapter'] : nil
  case adapter
  when 'mysql2'
    require 'active_record_read_only_error_fallback/extensions/mysql_database_statements'
  end
end
