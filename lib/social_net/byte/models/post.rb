require 'social_net/byte/api/request'
require 'social_net/byte/errors'

module SocialNet
  module Byte
    module Models
      class Post
        attr_reader :id,
                    :author_id,
                    :caption,
                    :category,
                    :mentions,
                    :date,
                    :video_src,
                    :thumb_src,
                    :comment_count,
                    :comments,
                    :like_count,
                    :loop_count

        def initialize(attrs = {})
          attrs.each{|k, v| instance_variable_set("@#{k}", v) unless v.nil?}
        end

        # Returns the existing Byte post matching the provided attributes or
        # nil when the post is not found.
        #
        # @return [SocialNet::Byte::Models::post] when the post is found.
        # @return [nil] when the post is not found.
        # @param [Hash] params the attributes to find a post by.
        # @option params [String] :id The Byte post’s id
        #   (case-insensitive).
        def self.find_by(params = {})
          find_by! params
        rescue Errors::UnknownPost
          nil
        end

        # Returns the existing Byte post matching the provided attributes or
        # nil when the post is not found, and raises an error when the post is not found.
        #
        # @return [SocialNet::Byte::Models::Post] the Byte post.
        # @param [Hash] params the attributes to find a post by.
        # @option params [String] :id The Byte post id
        #   (case-sensitive).
        # @raise [SocialNet::Errors::UnknownPost] if the post is unknown.
        def self.find_by!(params = {})
          if params[:id]
            find_by_id! params[:id]
          end
        end

      private

        def self.find_by_id!(id)
          request = Api::Request.new endpoint: "/post/id/#{id}"
          if post = request.run['data']
            new post.deep_transform_keys { |key| key.underscore.to_sym }
          else
            raise Errors::UnknownPost
          end
        end
      end
    end
  end
end
