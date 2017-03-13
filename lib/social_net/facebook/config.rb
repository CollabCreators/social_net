require 'social_net/facebook/api/configuration'

module SocialNet
  module Facebook
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

