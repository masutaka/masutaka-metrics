require 'fluent-logger'

class MasutakaMetrics
  class FluentLoggerWrapper
    def post(map)
      tag = 'masutaka.metrics'

      if fluent_logger.post(tag, map)
        return true
      end

      # Retry once
      if fluent_logger.last_error.is_a?(Errno::ECONNRESET)
        reset
        return fluent_logger.post(tag, map)
      end

      false
    end

    def last_error
      fluent_logger.last_error
    end

    private

    def fluent_logger
      @fluent_logger ||= ::Fluent::Logger::FluentLogger.new
    end

    def reset
      @fluent_logger = nil
    end
  end
end
