require 'social_net/byte/api/request'
require 'social_net/byte/errors'

module SocialNet
  module Byte
    module Models
      class User
        attr_reader :id,
                    :avatar_url,
                    :bio,
                    :display_name,
                    :follower_count,
                    :following_count,
                    :username,
                    :registration_date

        def initialize(attrs = {})
          attrs.each{|k, v| instance_variable_set("@#{k}", v) unless v.nil?}
        end

        # Returns the existing Byte user's most recent posts
        #
        # @return [SocialNet::Byte::Models::Post] when the posts are found.
        # @ param [Hash] params the attributes to find paginated posts by.
        # @option params [String] :next_page The next page of paginated posts.
        def posts(opts={})
          params = {endpoint: "/account/id/#{@id}/posts"}.merge! opts
          request = Api::Request.new params
          posts_data = request.run
          {}.tap do |k,v|
            k[:posts] = posts_data['data']['posts'].map{|post| Post.new post.deep_transform_keys { |key| key.underscore.to_sym }}
            k[:next_page] = posts_data['data']['cursor']
          end
        rescue Errors::ResponseError => error
          case error.response
            when Net::HTTPBadRequest then raise Errors::UnknownUser
            when Net::HTTPNotFound then raise Errors::UnknownUser
          end
        end

        # Returns the existing Byte user matching the provided attributes or
        # nil when the user is not found.
        #
        # @return [SocialNet::Byte::Models::User] when the user is found.
        # @return [nil] when the user is not found.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :username The Byte user’s username
        #   (case-insensitive).
        # @option params [String] :id The Byte user’s id
        #   (case-insensitive).
        def self.find_by(params = {})
          find_by! params
        rescue Errors::UnknownUser
          nil
        end

        # Returns the existing Byte user matching the provided attributes or
        # nil when the user is not found, and raises an error when the user account is private.
        #
        # @return [SocialNet::Byte::Models::User] the Byte user.
        # @param [Hash] params the attributes to find a user by.
        # @option params [String] :username The Byte user’s username
        #   (case-insensitive).
        # @option params [String] :id The Byte user’s id
        #   (case-insensitive).
        # @raise [SocialNet::Errors::UnknownUser] if the user account is unknown.
        def self.find_by!(params = {})
          if params[:username]
            find_by_username! params[:username]
          elsif params[:id]
            find_by_id! params[:id]
          end
        end

      private

        def self.find_by_username!(username)
          request = Api::Request.new endpoint: "/account/prefix/#{username}"
          response = request.run
          users = response['data']['accounts']
          if user = users.find{|u| u['username'].casecmp(username).zero?}
            new user.transform_keys { |key| key.underscore.to_sym }
          else
            raise Errors::UnknownUser
          end
        end

        def self.find_by_id!(id)
          request = Api::Request.new endpoint: "/account/id/#{id}"
          if user = request.run['data']
            new user.transform_keys { |key| key.underscore.to_sym }
          else
            raise Errors::UnknownUser
          end
        end
      end
    end
  end
end
