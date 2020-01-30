require 'social_net/byte/api/configuration'

module SocialNet
  module Byte
    module Config
      def configure
        yield configuration if block_given?
      end

      def configuration
        @configuration ||= Api::Configuration.new
      end
    end
  end
end

