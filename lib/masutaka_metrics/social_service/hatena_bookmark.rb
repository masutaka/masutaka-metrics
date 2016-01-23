require 'net/http'
require 'rexml/document'

class MasutakaMetrics
  class HatenaBookmark < SocialService
    def count
      # http://developer.hatena.ne.jp/ja/documents/bookmark/apis/getcount#total
      response = Net::HTTP.new('b.hatena.ne.jp').start do |http|
        request = <<EOS
<?xml version="1.0"?>
<methodCall>
  <methodName>bookmark.getTotalCount</methodName>
  <params>
    <param>
      <value><string>#{@blog_url}</string></value>
    </param>
  </params>
</methodCall>
EOS
        header = {
          'Content-Type'   => 'text/xml; charset=utf-8',
          'Content-Length' => request.bytesize.to_s,
          # Avoid '503 Service Temporarily Unavailable'
          'User-Agent'     => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36',
        }
        http.request_post('/xmlrpc', request, header)
      end

      doc = REXML::Document.new(response.body)
      doc.elements['/methodResponse/params/param/value/int'].text.to_i
    end
  end
end
