module SocialNet
  module Instagram
    module Models
      class Video
        attr_reader :id, :caption, :likes, :file, :thumbnail, :link

        def initialize(attrs = {})
          @id = attrs['id']
          @caption = attrs['caption']['text'] if attrs['caption']
          @likes = attrs['likes']['count']
          @file = attrs['videos']['standard_resolution']['url']
          @thumbnail = attrs['images']['standard_resolution']['url']
          @link = attrs['link']
        end
      end
    end
  end
end
