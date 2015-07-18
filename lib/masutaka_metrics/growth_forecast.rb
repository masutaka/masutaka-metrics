require 'net/http'
require 'uri'

class MasutakaMetrics
  class GrowthForecast
    def initialize settings
      @url          = settings['growth_forecast']['url']
      @service_name = settings['growth_forecast']['service_name']
      @section_name = settings['growth_forecast']['section_name']
    end

    def post_feedly(number)
      post('Feedly', number)
    end

    def post_livedoor_reader(number)
      post('livedoor Reader', number)
    end

    def post_hatena_bookmark(number)
      post('Hatena::Bookmark', number)
    end

    private

    def post(graph_name, number)
      uri = URI.escape("#{@url}/api/#{@service_name}/#{@section_name}/#{graph_name}", ' ')
      Net::HTTP.post_form URI.parse(uri), 'number' => number
    end
  end
end
