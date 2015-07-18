require 'net/http'
require 'uri'

class MasutakaMetrics
  class LivedoorReader < SocialService
    def subscribers
      # http://seesaawiki.jp/w/staff_reader/d/Count%20API
      api_uri = 'http://rpc.reader.livedoor.com/count?feedlink=' + @blog_rss
      Net::HTTP.get(URI.parse api_uri).to_i
    end
  end
end
