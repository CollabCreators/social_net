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
  let(:existing_video_shortcode) { 'BW-nC7xg8ZX' }
  let(:unknown_shortcode) { 'BQ-nC7xg8ZX' }
  let(:existing_image_shortcode) { 'BW8yP8FgXZt' }
  let(:existing_private_shortcode) { 'BX8sBI0hS9cyuR0iORRax8F3OamLIJZCwaZRyQ0' }
  let(:unknown_private_shortcode) { 'MX8sBI0hS9cyuR0iORRax8F3OamLIJZCwaZRyQ0' }

  describe '.find_by media_id' do
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

  describe '.find_by! media_id' do
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

  describe '.find_by! shortcode' do
    subject(:video) { SocialNet::Instagram::Video.find_by! shortcode: shortcode }

    context 'given an existing video\'s shortcode' do
      let(:shortcode) { existing_video_shortcode }

      it 'returns an object representing that video' do
        expect(video.id).to eq '1566861445805885015_487786346'
        expect(video.link).to eq 'https://www.instagram.com/p/BW-nC7xg8ZX/'
      end
    end

    context 'given a nonexistant video shortcode' do
      let(:shortcode) { unknown_shortcode }
      it { expect{video}.to raise_error SocialNet::Instagram::UnknownVideo }
    end

    context 'given an existing image shortcode' do
      let(:shortcode) { existing_image_shortcode }
      it { expect{video}.to raise_error SocialNet::Instagram::UnknownVideo }
    end
  end

  describe '.find_by! private_shortcode' do
    subject(:video) { SocialNet::Instagram::Video.find_by_private_shortcode! private_shortcode }

    context 'given an existing private video\'s shortcode' do
      let(:private_shortcode) { existing_private_shortcode }

      it 'returns an object representing that video' do
        expect(video.id).to eq 'BX8sBI0hS9cyuR0iORRax8F3OamLIJZCwaZRyQ0'
        expect(video.link).to eq 'https://www.instagram.com/p/BX8sBI0hS9cyuR0iORRax8F3OamLIJZCwaZRyQ0/'
      end
    end

    context 'given a nonexistant video shortcode' do
      let(:private_shortcode) { unknown_private_shortcode }
      it { expect{video}.to raise_error SocialNet::Instagram::UnknownVideo }
    end
  end
end
