require 'social_net/instagram/config'
require 'social_net/instagram/models'

module SocialNet
  module Instagram
    extend Config
    include Errors
    include Models
  end
end
