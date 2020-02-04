require 'social_net/byte/errors/response_error'
require 'social_net/byte/errors/unknown_user'
require 'active_support'
require 'active_support/core_ext'

module SocialNet
  module Byte
    module Api
      class Request
        def initialize(attrs = {})
          @host = 'api.byte.co'
          @username = attrs[:username]
          @endpoint = attrs.fetch :endpoint, "/account/id/#{@username}/posts"
          @block = attrs.fetch :block, -> (request) {add_access_token_and_cursor! request}
          @next_page = attrs[:next_page] if attrs[:next_page]
          @method = attrs.fetch :method, :get
        end

        def run
          print "#{as_curl}\n"
          case response = run_http_request
          when Net::HTTPOK
            rate_limit_reset response.header["x-ratelimit-remaining"].to_i
            JSON response.body
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
          @http_request ||= http_class.new(uri.request_uri).tap do |request|
            @block.call request
          end
        end

        def uri
          @uri ||= URI::HTTPS.build host: @host, path: @endpoint, query: query
        end

        def add_access_token_and_cursor!(request)
          request.add_field 'Authorization', SocialNet::Byte.configuration.access_token
        end

        def query
          {}.tap do |query|
            query.merge! cursor: @next_page if @next_page
          end.to_param
        end

        def rate_limit_reset(number_of_tries)
          puts number_of_tries
          if number_of_tries == 1
            puts "Sleeping 20 seconds to reset the rate limit"
            sleep 20
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
