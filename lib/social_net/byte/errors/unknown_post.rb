module SocialNet
  module Byte
    module Errors
      class UnknownPost < StandardError
        def message
          'Unknown post'
        end
      end
    end
  end
end
