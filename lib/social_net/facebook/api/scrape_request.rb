require 'social_net/facebook/errors/response_error'
require 'social_net/facebook/errors/unknown_video'
require 'active_support'
require 'active_support/core_ext'
require 'nokogiri'
require 'net/http'

module SocialNet
  module Facebook
    module Api
      class ScrapeRequest
        def initialize(attrs = {})
          @host = 'www.facebook.com'
          @username = attrs[:username]
          @video_id = attrs[:video_id]
          @path = attrs.fetch :path, "/#{attrs[:username]}/videos/#{attrs[:video_id]}/"
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
          m = data.content.match(/hd_src:"([^\\"]*)"/)

          raise Errors::UnknownVideo unless m
          {}.tap do |video|
            video['id'] = @video_id
            video['video_url'] = data.at("meta[property='og:url']")['content']
            video['link'] = m[1]
            video['caption'] = data.at("meta[name='description']")['content']
            video['thumbnail_url'] = data.at("meta[property='og:image']")['content']
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

# https://www.facebook.com/TimHowellADVENTURE/videos/1280907158777599/?v=1280907158777599

s = SocialNet::Facebook::Api::ScrapeRequest.new attrs={username: 'TimHowellADVENTURE', video_id: '1280907158777599'}

s.run