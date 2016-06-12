require 'clockwork'
require 'fluent-logger'
require 'logger'

class MasutakaMetrics
  def initialize(settings)
    @growth_forecast = GrowthForecast.new(settings)
    @feedly = Feedly.new(settings)
    @livedoor_reader = LivedoorReader.new(settings)
    @hatena_bookmark = HatenaBookmark.new(settings)
    @fetch_interval_seconds = settings['fetch_interval_seconds']
    @fluent_logger = ::Fluent::Logger::FluentLogger.new
    @logger = Logger.new(STDOUT)
  end

  def start
    Clockwork::handler {|job| send(job)}
    Clockwork::every(@fetch_interval_seconds, :post)
  end

  private

  def post
    feedly_subscribers = post_feedly
    hatena_bookmark_count = post_hatena_bookmark
    livedoor_reader_count = post_livedoor_reader

    metrics = {}
    metrics['feedly'] = feedly_subscribers if feedly_subscribers
    metrics['hatena_bookmark'] = hatena_bookmark_count if hatena_bookmark_count
    metrics['live_dwango_reader'] = livedoor_reader_count if livedoor_reader_count

    if metrics.empty?
      @logger.error('metrics is empty.')
      return false
    end

    @logger.info("metrics: #{metrics}")

    unless @fluent_logger.post('masutaka.metrics', metrics)
      @logger.warn("FluentLogger: #{@fluent_logger.last_error}")
    end
  end

  def post_feedly
    subscribers = @feedly.subscribers
    @growth_forecast.post_feedly(subscribers)
    @logger.info("feedly subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("feedly subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
    nil
  end

  def post_livedoor_reader
    subscribers = @livedoor_reader.subscribers
    @growth_forecast.post_livedoor_reader(subscribers)
    @logger.info("livedoor_reader subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("livedoor_reader subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
    nil
  end

  def post_hatena_bookmark
    subscribers = @hatena_bookmark.count
    @growth_forecast.post_hatena_bookmark(subscribers)
    @logger.info("hatena_bookmark subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("hatena_bookmark subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
    nil
  end
end
