require 'social_net/instagram/api/request'
require 'social_net/instagram/api/scrape_request'
require 'social_net/instagram/errors'

module SocialNet
  module Instagram
    module Models
      class Video
        attr_reader :id, :caption, :video_url, :thumbnail_url, :link

        def initialize(attrs = {})
          @id = attrs['id']
          @video_url = attrs['video_url']
          @thumbnail_url = attrs['thumbnail_url']
          @link = attrs['link']
          @caption = attrs['caption'] if attrs['caption']
        end

        # Returns the existing Instagram video matching the provided attributes or
        # nil when the video is not found.
        #
        # @return [SocialNet::Instagram::Models::Video] when the video is found.
        # @return [nil] when the video is not found.
        # @param [Hash] params the attributes to find a video by.
        # @option params [String] :media_id The Instagram video's media id.
        def self.find_by(params = {})
          find_by! params
        rescue Errors::UnknownVideo
          nil
        end

        # Returns the existing Instagram video matching the provided attributes or
        # raises an error when the video is not found.
        #
        # @return [SocialNet::Instagram::Models::Video] when the video is found.
        # @return [nil] when the video is not found.
        # @param [Hash] params the attributes to find a video by.
        # @option params [String] :media_id The Instagram video's media id.
        # @raise [SocialNet::Errors::UnknownVideo] if the video is not found.
        def self.find_by!(params = {})
          if params[:shortcode]
            find_by_shortcode! params[:shortcode]
          end
        end

        private

        def self.find_by_shortcode!(id)
          request = Api::ScrapeRequest.new shortcode: id
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
