require 'spec_helper'
require 'social_net/byte'

describe SocialNet::Byte::User, :vcr do
  before :all do
    SocialNet::Byte.configure do |config|
      if config.access_token.blank?
        config.access_token = 'ACCESS_TOKEN'
      end
    end
  end

  let(:existing_username) { 'ollie' }
  let(:unknown_username) { '01LjqweoojkjR' }
  let(:existing_user_id_with_no_posts) { 'EGDL2NQ6WRFQRBSY6Q5D5HWKHQ' }
  let(:existing_id) { 'PUEMKGYDBFAZ3HSRSAFGBAI5HA' }
  let(:unknown_id) { '123456' }
  let(:existing_cursor) { 'CXWZB7CTMYLTA' }

  describe '.find_by username' do
    subject(:user) { SocialNet::Byte::User.find_by username: username }

    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing that user' do
        expect(user.username).to eq 'ollie'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect(user).to be_nil }
    end
  end

  describe '.find_by id' do
    subject(:user) { SocialNet::Byte::User.find_by id: id }

    context 'given an existing (case-sensitive) ID' do
      let(:id) { existing_id }

      it 'returns an object representing that user' do
        expect(user.username).to eq 'ollie'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown ID' do
      let(:id) { unknown_id }
      it { expect(user).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:user) { SocialNet::Byte::User.find_by! username: username }

    context 'given an existing (case-sensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing that user' do
        expect(user.username).to eq 'ollie'
        expect(user.follower_count).to be_an Integer
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect{user}.to raise_error SocialNet::Byte::UnknownUser }
    end
  end

  describe '.posts' do
    subject(:user) { SocialNet::Byte::User.find_by id: id }
    context 'given an existing user with posts' do
      let(:id) { existing_id }

      it 'returns an array of video posts from the user' do
        expect(user.posts[:posts]).to be_an Array
        expect(user.posts[:posts].first).to be_an_instance_of SocialNet::Byte::Post
      end
    end

    context 'given an existing user with no posts' do
      let(:id) { existing_user_id_with_no_posts }

      it 'returns an empty array from the user' do
        expect(user.posts[:posts]).to be_an Array
        expect(user.posts[:posts]).to be_empty
      end
    end

    context 'given an existing user with paginated posts' do
      let(:id) { existing_id }
      let(:next_page) { existing_cursor }

      it 'returns an array of video posts from the user' do
        expect(user.posts({next_page: next_page})[:posts]).to be_an Array
        expect(user.posts({next_page: next_page})[:posts].first).to be_an_instance_of SocialNet::Byte::Post
        expect(user.posts({next_page: next_page})[:next_page]).not_to eq next_page
      end
    end
  end
end
