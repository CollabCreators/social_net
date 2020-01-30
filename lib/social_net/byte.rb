require 'social_net/byte/config'
require 'social_net/byte/models'
require 'social_net/byte/errors'

module SocialNet
  module Byte
    extend Config
    include Errors
    include Models
  end
end
