class MasutakaMetrics
  class SocialService
    def initialize(settings)
      @blog_url = settings['blog']['url']
      @blog_rss = settings['blog']['rss']
    end
  end
end

require_relative 'social_service/feedly'
require_relative 'social_service/hatena_bookmark'
require_relative 'social_service/livedoor_reader'
