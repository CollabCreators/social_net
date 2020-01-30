module SocialNet
  module Byte
    module Errors
      class ResponseError < StandardError
        attr_reader :response

        def initialize(response = {})
          @response = response
          super response
        end
      end
    end
  end
end
