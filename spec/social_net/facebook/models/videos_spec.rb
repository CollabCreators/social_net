require 'spec_helper'
require 'social_net/facebook'

describe SocialNet::Facebook::Video, :vcr do
      let(:existing_video_id) { '1596466537097289' }
      describe '.find_by! id' do
        subject(:video) do
          user = SocialNet::Facebook::User.new user_name: 'collabcreators'
          user.find_video existing_video_id
        end

        context 'given an existing public video\'s video id' do
          let(:video_id) { existing_video_id }

          it 'returns an object representing that video' do
            expect(video.id).to eq '1596466537097289'
            expect(video.link).to eq 'https://www.facebook.com/collabcreators/videos/1596466537097289/'
          end
        end
      end

end
