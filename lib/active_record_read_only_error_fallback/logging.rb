# frozen_string_literal: true
module ActiveRecordReadOnlyErrorFallback
  class Logging
    class << self
      attr_accessor :handler

      def call(error_or_locations)
        handler.call(error_or_locations) if handler&.respond_to?(:call)
      rescue
        # nothing to do
      end
    end
  end
end
