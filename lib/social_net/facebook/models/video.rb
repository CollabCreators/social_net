require 'social_net/facebook/api/request'
require 'social_net/facebook/errors'

module SocialNet
  module Facebook
    module Models
      class Video
        attr_reader :id, :video_url, :link

        def initialize(attrs={})
          @id = attrs[:id]
          @link = attrs[:link]
          @video_url = attrs[:video_url]
        end
      end
    end
  end
end
