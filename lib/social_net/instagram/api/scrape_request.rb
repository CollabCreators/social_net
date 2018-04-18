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
          data_string = data.search("script")[2].children.first
          ig_data = eval data_string.content.gsub(/window\._sharedData = /,"").gsub(/null/,'nil')
          video_data = ig_data[:entry_data][:PostPage][0][:graphql][:shortcode_media]
          raise Errors::UnknownVideo unless video_data[:is_video]
          {}.tap do |video|
            video['id'] = video_data[:shortcode]
            video['likes'] = {'count' => video_data[:edge_media_preview_like][:count]}
            video['videos'] = {'standard_resolution' => {'url' => video_data[:video_url]}}
            video['images'] = {'standard_resolution' => {'url' => video_data[:display_url]}}
            video['link'] = "https://www.instagram.com/p/#{video_data[:shortcode]}/"
            if video_data[:edge_media_to_caption][:edges].present?
              video['caption'] = {'text' => video_data[:edge_media_to_caption][:edges][0][:node][:text]}
            end
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