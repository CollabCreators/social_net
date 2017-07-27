require 'social_net/instagram/api/request'
require 'social_net/instagram/errors'

module SocialNet
  module Instagram
    module Models
      class Video
        attr_reader :id, :caption, :likes, :file, :thumbnail, :link

        def initialize(attrs = {})
          @id = attrs['id']
          @caption = attrs['caption']['text'] if attrs['caption']
          @likes = attrs['likes']['count']
          @file = attrs['videos']['standard_resolution']['url']
          @thumbnail = attrs['images']['standard_resolution']['url']
          @link = attrs['link']
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
          if params[:media_id]
            find_by_id! params[:media_id]
          elsif params[:shortcode]
            find_by_id! "shortcode/#{params[:shortcode]}"
          end
        end

        private

        def self.find_by_id!(id)
          request = Api::Request.new endpoint: "media/#{id}"
          video = request.run
          raise Errors::UnknownVideo if video['type'] == 'image'
          new video
        rescue Errors::ResponseError => error
          case error.response
            when Net::HTTPBadRequest then raise Errors::UnknownVideo
          end
        end
      end
    end
  end
end
