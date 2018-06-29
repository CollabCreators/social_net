require 'spec_helper'
require 'social_net/instagram'

describe SocialNet::Instagram::User, :vcr do
  before :all do
    SocialNet::Instagram.configure do |config|
      if config.access_token.blank?
        config.access_token = 'ACCESS_TOKEN'
      end
    end
  end

  let(:existing_username) { 'Collab' }
  let(:unknown_username) { '01LjqweoojkjR' }
  let(:private_username) { '4ever_kelz' }
  let(:nonexistant_username) { 'ajmgangsta' }

  describe '.find_by' do
    subject(:user) { SocialNet::Instagram::User.find_by username: username }

    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing that user' do
        expect(user.username).to eq 'collab'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect(user).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:user) { SocialNet::Instagram::User.find_by! username: username }

    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing that user' do
        expect(user.username).to eq 'collab'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect{user}.to raise_error SocialNet::Instagram::UnknownUser }
    end

    context 'given a private username' do
      let(:username) { private_username }
      it { expect{user}.to raise_error SocialNet::Instagram::PrivateUser }
    end
  end

  describe '.videos' do
    subject(:user) { SocialNet::Instagram::User.new username: username }
    context 'given an existing user' do
      let(:username) { existing_username }

      it 'returns an array of video posts from the user' do
        expect(user.videos).to be_an Array
        expect(user.videos.first).to be_an_instance_of SocialNet::Instagram::Video
      end
    end

    context 'given a nonexistant user' do
      let(:username) { nonexistant_username }
      it { expect{user.videos}.to raise_error SocialNet::Instagram::UnknownUser }
    end
  end
end
