require 'clockwork'
require 'fluent-logger'
require 'logger'

class MasutakaMetrics
  def initialize(settings)
    @feedly = Feedly.new(settings)
    @livedoor_reader = LivedoorReader.new(settings)
    @hatena_bookmark = HatenaBookmark.new(settings)
    @fetch_interval_seconds = settings['fetch_interval_seconds']
    @fluent_logger = ::Fluent::Logger::FluentLogger.new(nil, host: settings['fluent']['host'], port: settings['fluent']['port'])
    @fluent_tag = settings['fluent']['tag']
    @logger = Logger.new(STDOUT)
  end

  def start
    Clockwork::handler {|job| send(job)}
    Clockwork::every(@fetch_interval_seconds, :post)
  end

  private

  def post
    metrics = {}
    metrics['feedly'] = feedly_count
    metrics['hatena_bookmark'] = hatena_bookmark_count
    metrics['live_dwango_reader'] = live_dwango_reader_count

    metrics.select! { |k,v| v != nil }

    if metrics.empty?
      @logger.error('metrics is empty.')
      return false
    end

    @logger.info("metrics: #{metrics}")

    unless @fluent_logger.post(@fluent_tag, metrics)
      # will be retry at next time or program exiting
      @logger.warn("FluentLogger: #{@fluent_logger.last_error}")
    end
  end

  def feedly_count
    subscribers = @feedly.subscribers
    @logger.info("feedly subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("feedly subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
    nil
  end

  def hatena_bookmark_count
    subscribers = @hatena_bookmark.count
    @logger.info("hatena_bookmark subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("hatena_bookmark subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
    nil
  end

  def live_dwango_reader_count
    subscribers = @livedoor_reader.subscribers
    @logger.info("livedoor_reader subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("livedoor_reader subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
    nil
  end
end

