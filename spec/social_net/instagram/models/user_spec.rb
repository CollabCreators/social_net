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
  end
end
