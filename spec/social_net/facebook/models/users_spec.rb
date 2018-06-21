require 'spec_helper'

describe SocialNet::Facebook::User, :vcr do
  let(:unknown_username) { 'qeqwe09qlkmhkjh' }
  let(:existing_username) { '1453280268327112' }
  let(:existing_handle) { 'collabcreators' }
  let(:existing_video) { '1596466537097289' }
  let(:unknown_video) { '1596466537097288' }

  describe '.find_by' do
    subject(:user) { SocialNet::Facebook::User.find_by username: username }

    context 'given an existing (case-insensitive) username' do
      let (:username) { existing_username }

      it 'returns an object representing the user' do
        expect(user.first_name).to eq 'Jeremy'
        expect(user.last_name).to eq 'Dev'
        expect(user.gender).to eq 'male'
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect(user).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:user) { SocialNet::Facebook::User.find_by! username: username }

    context 'given an existing (case-insensitive) username' do
      let(:username) { existing_username }

      it 'returns an object representing the user' do
        expect(user.first_name).to eq 'Jeremy'
        expect(user.last_name).to eq 'Dev'
        expect(user.gender).to eq 'male'
      end
    end

    context 'given an unknown username' do
      let(:username) { unknown_username }
      it { expect{user}.to raise_error SocialNet::Facebook::UnknownUser }
    end
  end

  describe '.find_video' do
    subject(:facebook_video) do
      user = SocialNet::Facebook::User.new user_name: username
      user.find_video video
    end

    context 'given an existing video id' do
      let(:username) { existing_handle }
      let(:video) { existing_video }

      it 'returns an object representing a video' do
        expect(facebook_video.id).to eq '1596466537097289'
        expect(facebook_video.video_url).to eq 'https://www.facebook.com/collabcreators/videos/1596466537097289/'
        expect(facebook_video.link).to be_present
      end
    end

    context 'given a nonexistant video video_id' do
      let(:username) { existing_handle }
      let(:video) { unknown_video }

      it { expect{facebook_video}.to raise_error SocialNet::Facebook::UnknownVideo }
    end
  end
end
