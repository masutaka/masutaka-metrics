require 'clockwork'
require 'logger'

class MasutakaMetrics
  def initialize(settings)
    @growth_forecast = GrowthForecast.new(settings)
    @feedly = Feedly.new(settings)
    @livedoor_reader = LivedoorReader.new(settings)
    @hatena_bookmark = HatenaBookmark.new(settings)
    @fetch_interval_seconds = settings['fetch_interval_seconds']
    @fluent_logger_wrapper = FluentLoggerWrapper.new
    @logger = Logger.new(STDOUT)
  end

  def start
    Clockwork::handler {|job| send(job)}
    Clockwork::every(@fetch_interval_seconds, :post)
  end

  private

  def post
    metrics = {
      'feedly'             => post_feedly,
      'hatena_bookmark'    => post_hatena_bookmark,
      'live_dwango_reader' => post_livedoor_reader,
    }

    @logger.info("metrics: #{metrics}")

    unless @fluent_logger_wrapper.post(metrics)
      @logger.error("FluentLogger: #{@fluent_logger_wrapper.last_error}")
    end
  end

  def post_feedly
    subscribers = @feedly.subscribers
    @growth_forecast.post_feedly(subscribers)
    @logger.info("feedly subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("feedly subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
  end

  def post_livedoor_reader
    subscribers = @livedoor_reader.subscribers
    @growth_forecast.post_livedoor_reader(subscribers)
    @logger.info("livedoor_reader subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("livedoor_reader subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
  end

  def post_hatena_bookmark
    subscribers = @hatena_bookmark.count
    @growth_forecast.post_hatena_bookmark(subscribers)
    @logger.info("hatena_bookmark subscribers: #{subscribers}")
    subscribers
  rescue => e
    @logger.error("hatena_bookmark subscribers: unknown, class=#{e.class}, backtrace=#{e.backtrace.join(' | ')}")
  end
end
