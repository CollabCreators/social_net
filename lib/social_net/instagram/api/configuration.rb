module SocialNet
  module Instagram
    module Api
      class Configuration
        attr_accessor :access_token

        def initialize
          @access_token = ENV['INSTAGRAM_ACCESS_TOKEN']
        end
      end
    end
  end
end
