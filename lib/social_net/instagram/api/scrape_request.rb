require 'social_net/instagram/errors/response_error'
require 'social_net/instagram/errors/unknown_user'
require 'active_support'
require 'active_support/core_ext'
require 'nokogiri'

module SocialNet
  module Instagram
    module Api
      class ScrapeRequest
        def initialize(attrs = {})
          @host = 'www.instagram.com'
          @shortcode = attrs[:shortcode]
          @path = attrs.fetch :path, "/p/#{attrs[:shortcode]}/"
          @method = attrs.fetch :method, :get
        end

        def run
          print "#{as_curl}\n"
          case response = run_http_request
          when Net::HTTPOK
            data_string = Nokogiri::HTML response.body
            parse_video_data data_string
          else
            raise Errors::ResponseError, response
          end
        end

      private
        def run_http_request
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request http_request
          end
        end

        def http_request
          http_class = "Net::HTTP::#{@method.capitalize}".constantize
          @http_request ||= http_class.new(uri.request_uri)
        end

        def uri
          @uri ||= URI::HTTPS.build host: @host, path: @path
        end

        def parse_video_data(data)
          raise Errors::UnknownVideo unless data.at("meta[property='og:type']")['content'] == 'video'
          {}.tap do |video|
            video['id'] = @shortcode
            video['video_url'] = data.at("meta[property='og:video']")['content']
            video['thumbnail_url'] = data.at("meta[property='og:image']")['content']
            video['link'] = data.at("meta[property='og:url']")['content']
            video['caption'] = data.at("meta[property='og:description']")['content']
          end
        end

        def as_curl
          'curl'.tap do |curl|
            curl <<  " -X #{http_request.method}"
            http_request.each_header do |name, value|
              curl << %Q{ -H "#{name}: #{value}"}
            end
            curl << %Q{ -d '#{http_request.body}'} if http_request.body
            curl << %Q{ "#{@uri.to_s}"}
          end
        end
      end
    end
  end
end
