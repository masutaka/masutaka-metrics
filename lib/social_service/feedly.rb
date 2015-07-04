require 'net/http'
require 'uri'
require 'json'

class BlogSubscribersNumber
  class Feedly < SocialService
    def subscribers
      # http://developer.feedly.com/v3/feeds/#get-the-metadata-about-a-specific-feed
      api_uri = 'http://cloud.feedly.com/v3/feeds/' + URI.escape("feed/#{@blog_rss}", ':/')
      JSON.parse(Net::HTTP.get(URI.parse(api_uri)))['subscribers']
    end
  end
end
