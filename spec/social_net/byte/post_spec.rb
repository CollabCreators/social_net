require 'spec_helper'
require 'social_net/byte'

describe SocialNet::Byte::Post, :vcr do
  before :all do
    SocialNet::Byte.configure do |config|
      if config.access_token.blank?
        config.access_token = 'ACCESS_TOKEN'
      end
    end
  end

  let(:existing_post_id) { 'WZPPQ5LQJZAAHP4BWFLM6PRBNM' }
  let(:nonexistant_post_id) { 'XAMM45LQJZNHHP4EWFLM6PMKIO' }

  describe '.find_by id' do
    subject(:post) { SocialNet::Byte::Post.find_by id: id }

    context 'given an existing (case-sensitive) post id' do
      let(:id) { existing_post_id }

      it 'returns an object representing that post' do
        expect(post.id).to eq 'WZPPQ5LQJZAAHP4BWFLM6PRBNM'
        expect(post.comment_count).to be_an Integer
      end
    end

    context 'given a non-existant post id' do
      let(:id) { nonexistant_post_id }

      it { expect(post).to be_nil }
    end
  end

  describe '.find_by!' do
    subject(:post) { SocialNet::Byte::Post.find_by! id: id }

    context 'given an existing (case-sensitive) post id' do
      let(:id) { existing_post_id }

      it 'returns an object representing that post' do
        expect(post.id).to eq 'WZPPQ5LQJZAAHP4BWFLM6PRBNM'
        expect(post.comment_count).to be_an Integer
      end
    end

    context 'given a non-existant post id' do
      let(:id) { nonexistant_post_id }

      it { expect{post}.to raise_error SocialNet::Byte::UnknownPost }
    end
  end
end
