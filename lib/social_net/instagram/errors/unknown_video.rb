module SocialNet
  module Instagram
    module Errors
      class UnknownVideo < StandardError
        def message
          'Unknown video'
        end
      end
    end
  end
end
