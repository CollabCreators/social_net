require 'social_net/facebook/config'
require 'social_net/facebook/models'
require 'social_net/facebook/errors'

module SocialNet
  module Facebook
    extend Config
    include Errors
    include Models
  end
end
