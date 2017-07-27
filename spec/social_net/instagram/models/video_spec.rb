require 'spec_helper'
require 'social_net/instagram'

describe SocialNet::Instagram::Video, :vcr do
  before :all do
    SocialNet::Instagram.configure do |config|
      if config.access_token.blank?
        config.access_token = 'ACCESS_TOKEN'
      end
    end
  end

  let(:existing_media_id) { '1531332985868221389' }
  let(:unknown_media_id) { '31231231231231232' }

  describe '.find_by' do
    subject(:video) { SocialNet::Instagram::Video.find_by media_id: media_id }

    context 'given an existing video\'s media id' do
      let(:media_id) { existing_media_id }

      it 'returns an object representing that video' do
        expect(video.id).to eq '1531332985868221389_2920261222'
        expect(video.link).to eq 'https://www.instagram.com/p/BVAYzy_g3vN/'
      end
    end

    context 'given a nonexistant video' do
      let(:media_id) { unknown_media_id }
      it { expect(video).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:video) { SocialNet::Instagram::Video.find_by! media_id: media_id }

    context 'given an existing video\'s media id' do
      let(:media_id) { existing_media_id }

      it 'returns an object representing that video' do
        expect(video.id).to eq '1531332985868221389_2920261222'
        expect(video.link).to eq 'https://www.instagram.com/p/BVAYzy_g3vN/'
      end
    end

    context 'given a nonexistant video' do
      let(:media_id) { unknown_media_id }
      it { expect{video}.to raise_error SocialNet::Instagram::UnknownVideo }
    end
  end
end
