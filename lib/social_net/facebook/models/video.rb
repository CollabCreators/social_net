require 'social_net/facebook/api/request'
require 'social_net/facebook/errors'

module SocialNet
  module Facebook
    module Models
      class Video
        attr_reader :id, :link, :video_url, :thumbnail_url, :caption

        def initialize(attrs={})
          @id = attrs['id']
          @link = attrs['link']
          @video_url = attrs['video_url']
          @thumbnail_url = attrs['thumbnail_url']
          @caption = attrs['caption'] if attrs['caption']
        end

        # Returns the existing Facebook video matching the provided attributes or
        # nil when the video is not found.
        #
        # @return [SocialNet::Facebook::Models::Video] when the video is found.
        # @return [nil] when the video is not found.
        # @param [Hash] params the attributes to find a video by.
        # @option params [String] :media_id The Facebook video's media id.
        def self.find_by(params = {})
          find_by! params
        rescue Errors::UnknownVideo
          nil
        end

        # Returns the existing Facebook video matching the provided attributes or
        # raises an error when the video is not found.
        #
        # @return [SocialNet::Facebook::Models::Video] when the video is found.
        # @return [nil] when the video is not found.
        # @param [Hash] params the attributes to find a video by.
        # @option params [String] :media_id The Facebook video's media id.
        # @raise [SocialNet::Errors::UnknownVideo] if the video is not found.
        def self.find_by!(params = {})
          if params[:video_id] && params[:username]
            find_by_username_and_video_id! params[:username], params[:video_id]
          end
        end

        private

        def self.find_by_username_and_video_id!(username, video_id)
          request = Api::ScrapeRequest.new username: username, video_id: video_id
          video = request.run
          new video
        rescue Errors::ResponseError => error
          case error.response
          when Net::HTTPBadRequest then raise Errors::UnknownVideo
          when Net::HTTPNotFound then raise Errors::UnknownVideo
          end
        end
      end
    end
  end
end
