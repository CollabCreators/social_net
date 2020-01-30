module SocialNet
  module Byte
    module Api
      class Configuration
        attr_accessor :access_token

        def initialize
          @access_token = ENV['BYTE_ACCESS_TOKEN']
        end
      end
    end
  end
end
