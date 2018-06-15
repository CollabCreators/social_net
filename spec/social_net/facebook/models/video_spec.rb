require 'spec_helper'
require 'social_net/facebook'

describe SocialNet::Facebook::Video, :vcr do
  let(:existing_video_id) { '1596466537097289' }
  let(:unknown_video_id) { '1596466537097288' }
  let(:username){ 'collabcreators' }
  describe '.find_by! id' do
    subject(:video) do
      SocialNet::Facebook::Video.find_by!(username: username, video_id: video_id)
    end

    context 'given an existing public video\'s video id' do
      let(:video_id) { existing_video_id }

      it 'returns an object representing that video' do
        expect(video.id).to eq video_id
        expect(video.video_url).to eq 'https://www.facebook.com/collabcreators/videos/1596466537097289/'
        expect(video.link).to be_present
      end
    end

    context 'given a nonexistant video video_id' do
      let(:video_id) { unknown_video_id }
      it { expect{video}.to raise_error SocialNet::Facebook::UnknownVideo }
    end
  end
end
