require 'clockwork'
require 'logger'

class MasutakaMetrics
  def initialize(settings)
    @growth_forecast = GrowthForecast.new(settings)
    @feedly = Feedly.new(settings)
    @livedoor_reader = LivedoorReader.new(settings)
    @hatena_bookmark = HatenaBookmark.new(settings)
    @fetch_interval_seconds = settings['fetch_interval_seconds']
    @logger = Logger.new(STDOUT)
  end

  def start
    Clockwork::handler {|job| send(job)}
    Clockwork::every(@fetch_interval_seconds, :post)
  end

  private

  def post
    post_feedly
    post_livedoor_reader
    post_hatena_bookmark
  end

  def post_feedly
    subscribers = @feedly.subscribers
    @growth_forecast.post_feedly(subscribers)
    @logger.info("feedly subscribers: #{subscribers}")
  end

  def post_livedoor_reader
    subscribers = @livedoor_reader.subscribers
    @growth_forecast.post_livedoor_reader(subscribers)
    @logger.info("livedoor_reader subscribers: #{subscribers}")
  end

  def post_hatena_bookmark
    subscribers = @hatena_bookmark.count
    return unless subscribers
    @growth_forecast.post_hatena_bookmark(subscribers)
    @logger.info("hatena_bookmark subscribers: #{subscribers}")
  end
end
