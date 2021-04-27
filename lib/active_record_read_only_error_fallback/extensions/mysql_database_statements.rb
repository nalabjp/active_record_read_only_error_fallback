# frozen_string_literal: true
require "active_record/connection_adapters/mysql2_adapter"

module ActiveRecordReadOnlyErrorFallback
  module Extensions
    module MysqlDatabaseStatements
      def execute(*)
        ActiveRecordReadOnlyErrorFallback::QueryFallback.call { super }
      end

      private

      def exec_stmt_and_free(*)
        ActiveRecordReadOnlyErrorFallback::QueryFallback.call { super }
      end
    end
  end
end
ActiveRecord::ConnectionAdapters::Mysql2Adapter.prepend(ActiveRecordReadOnlyErrorFallback::Extensions::MysqlDatabaseStatements)
