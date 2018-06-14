module SocialNet
  module Facebook
    module Errors
      class UnknownVideo < StandardError
        def message
          'Unknown video'
        end
      end
    end
  end
end
