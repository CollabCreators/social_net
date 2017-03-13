require 'social_net/instagram/api/configuration'

module SocialNet
  module Instagram
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

