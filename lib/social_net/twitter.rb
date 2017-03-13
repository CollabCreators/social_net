require 'social_net/twitter/config'
require 'social_net/twitter/errors'
require 'social_net/twitter/models'

module SocialNet
  module Twitter
    extend Config
    include Errors
    include Models
  end
end